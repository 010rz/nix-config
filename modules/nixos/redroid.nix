{ lib, config, pkgs, ... }:
let
  cfg = config.modules.services.redroid;
in
{
  options.modules.services.redroid.enable =
    lib.mkEnableOption "redroid (Android 15 in podman container, GPU 加速 via iGPU)";

  config = lib.mkIf cfg.enable {
    # 持久化 Android 数据 (/data 分区)
    systemd.tmpfiles.rules = [
      "d /var/lib/redroid/data 0755 root root - -"
    ];

    virtualisation.oci-containers.containers.redroid = {
      # 锁 Android 14：是当前内核 (CONFIG_DMABUF_HEAPS=n) 能跑的最新版
      # 想升 15/16 需在 boot.nix 加 boot.kernelPatches 启用 DMABUF_HEAPS，会触发完整内核重编 30-60 分钟
      image = "redroid/redroid:14.0.0-latest";
      autoStart = true;
      ports = [ "5555:5555" ];                  # ADB
      volumes = [ "/var/lib/redroid/data:/data" ];
      extraOptions = [
        "--privileged"
        "--device=/dev/dri"                     # iGPU 直通给 Mesa 用
      ];
      # redroid 启动参数（androidboot.* 等价于 Android 内核 cmdline）
      cmd = [
        "androidboot.redroid_gpu_mode=host"     # 走宿主 GPU 加速（Mesa /dev/dri/card0 = Intel iGPU）
        "androidboot.use_memfd=true"            # 用 memfd 替代旧 ashmem (你内核 CONFIG_MEMFD_CREATE=y)
        "androidboot.redroid_width=1920"
        "androidboot.redroid_height=1080"
        "androidboot.redroid_fps=60"
      ];
    };

    # CLI 工具
    environment.systemPackages = with pkgs; [
      android-tools  # 提供 adb
      scrcpy         # 投屏 + 鼠标键盘控制 GUI
    ];
  };

  # 用法（容器跑起来后）：
  #   adb connect localhost:5555     # 第一次连
  #   scrcpy -s localhost:5555       # 打开投屏窗口，能用鼠标键盘
  #   adb install xxx.apk            # 装应用
  #   adb shell                      # 进 Android shell
  #
  # 装应用商店（没 Google Play）:
  #   下 F-Droid / Aurora Store / 酷安的 APK 后 adb install
}
