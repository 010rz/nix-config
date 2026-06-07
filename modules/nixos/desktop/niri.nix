{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.wayland;
in
{
  config = lib.mkIf cfg.enable {
    # Niri 编译器（注册为会话）
    programs.niri.enable = true;

    # Wayland / Chromium-Electron 必需
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      # WLR_NO_HARDWARE_CURSORS = "1";  # 旧驱动 HW cursor bug 的变通，NVIDIA 570+ 已修
      #                                  # 强制软件光标会掉帧，移除让 NVIDIA 走硬件加速
    };

    # 把"打开终端"的 MIME 默认指向 ghostty
    xdg.mime.defaultApplications = {
      "x-scheme-handler/terminal" = "ghostty.desktop";
    };

    # xdg-desktop-portal，文件选择器 / 截图 / 屏幕共享走 GTK 后端
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # dms-shell：跟 niri 配套的状态栏 / 通知 / 主题等
    programs.dms-shell = {
      enable = true;
      systemd.enable = true;
      enableDynamicTheming = true;
      enableSystemMonitoring = true;
      enableClipboardPaste = true;
    };
  };
}
