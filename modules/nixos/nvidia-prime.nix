{ lib, config, ... }:
let
  cfg = config.modules.hardware.nvidia-prime;
in
{
  options.modules.hardware.nvidia-prime.enable =
    lib.mkEnableOption "NVIDIA Optimus laptop with PRIME sync";

  config = lib.mkIf cfg.enable {
    # 1) OpenGL 硬件加速（Wayland + 32 位 game 都需要）
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # 2) 装 NVIDIA 闭源/开源驱动
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true; # Wayland 必需

      # Optimus suspend：true 让驱动备份 VRAM 到 RAM 跨 suspend（false 时驱动不参与，唤醒会乱）
      # 已在 stable 26.05 + 内核 7.0.11 + 这台 RTX 5080 Max-Q 上验证合盖唤醒正常 (2026-06-07)
      powerManagement.enable = true;
      powerManagement.finegrained = false;  # finegrained 是 offload 模式专用

      # 新的开源内核模块，性能跟闭源几乎一致
      open = true;
      nvidiaSettings = true;

      # Optimus 笔电 CPU↔GPU 动态功耗分配；启用后注册 nvidia-powerd.service
      # 已验证 (2026-06-07): EnableGpuFirmware=18, DynamicPowerManagement=3，powerd 运行无报错
      dynamicBoost.enable = lib.mkForce true;

      # 在 nixos-26.05 channel 上，nvidiaPackages.stable 和 .production 都
      # 解析到同一个 derivation (2026-06-07 验证：rfacrwa133a0xi...-nvidia-x11-595.71.05)
      # 所以 ryan4yin 推的 production 在这个 channel 上跟 stable 完全等价，没必要换
      # 未来 channel 更新后这两个 alias 可能分叉，到时候再考虑
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # 3) PRIME sync：外接显示器才能正常驱动
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Niri/Wayland 在 NVIDIA 上的开关
    # modeset=1 启用 KMS (Wayland 必需)
    # fbdev=1 让 nvidia 驱动早接管 /dev/fb0，避免开机过程中的黑闪
    # 已在 stable 26.05 + 内核 7.0.11 + RTX 5080 Max-Q 上单变量验证可用 (2026-06-07)
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    # NVIDIA + Wayland 用户会话环境变量
    # 必须放在 NixOS 层（不能用 home-manager 的 home.sessionVariables）：
    # HM 那个只写到 profile.d/.sh，登录 shell 才 source；
    # Niri 从 gdm → systemd 启动不走登录 shell，所以 HM 那条路对 Wayland 会话无效。
    # 走 environment.sessionVariables → /etc/set-environment → PAM 注入会话 → systemd 继承
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";          # VA-API 视频解码走 NVIDIA NVDEC
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";  # OpenGL Vendor Neutral Dispatch 选 NVIDIA
      NVD_BACKEND = "direct";                # nvidia-vaapi-driver 用 direct 模式
      GBM_BACKEND = "nvidia-drm";            # Wayland buffer 走 nvidia-drm
    };
  };
}
