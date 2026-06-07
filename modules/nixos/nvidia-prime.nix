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

      # 用 stable，已验证在 nixos-26.05 (内核 7.0.11) 上启动正常 (2026-06-07)
      #
      # 当时跟着 ryan4yin 改成 production + dynamicBoost.enable + nvidia-drm.fbdev=1 后黑屏，
      # 但那次失败在 unstable channel + 内核 7.0.10 上发生，
      # 真正元凶大概率是 unstable 当时锁的内核与这台机器不兼容，跟这三项没单独验证过的因果。
      # 想用 production / dynamicBoost / fbdev 的话：保持 stable channel 不变，
      # 一次只改一项跑 `nixos-rebuild switch` + 重启，看哪一项打破启动。
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # 3) PRIME sync：外接显示器才能正常驱动
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Niri/Wayland 在 NVIDIA 上的开关
    # 只开 modeset=1。fbdev=1 也可能有用但未在这台机器上单独验证过——可以另开一行试。
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  };
}
