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

      # Optimus suspend：必须 enable = true 才能让驱动备份 VRAM 到 RAM 跨 suspend
      # （false 时驱动不参与，唤醒会乱）
      # 之前 unstable + 7.0.10 上试过失败，现在 stable + 7.0.11 重试
      powerManagement.enable = true;
      powerManagement.finegrained = false;  # finegrained 是 offload 模式专用

      # 新的开源内核模块，性能跟闭源几乎一致
      open = true;
      nvidiaSettings = true;

      # ⚠️ 这台机器 (MSI Titan 16 AI 2025 + RTX 5080 Max-Q) 试过同时启用以下三项：
      #     package = nvidiaPackages.production
      #     dynamicBoost.enable = true
      #     boot.kernelParams += "nvidia-drm.fbdev=1"
      # 结果开机黑屏。回滚到 stable + 不启用 dynamicBoost + 不加 fbdev。
      # 如果未来想再试，一次只改一个，单独验证哪个是元凶。
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # 3) PRIME sync：外接显示器才能正常驱动
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Niri/Wayland 在 NVIDIA 上的开关
    # ⚠️ 只保留 modeset=1，fbdev=1 在这台机器上会黑屏 (2026-06-07)
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  };
}
