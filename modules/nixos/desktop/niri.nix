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

    # xdg-desktop-portal —— 浏览器 / Electron / Zoom / OBS 等通过 portal 跟桌面交互
    # 文件选择器 / 截图 / 屏幕共享 / 默认应用打开都走这里
    xdg.portal = {
      enable = true;
      # 让 xdg-open 走 portal（修复 Steam / Discord 这些 FHS-wrapped 程序里
      # 点链接打不开浏览器、点文件不弹文件管理器的 bug）
      xdgOpenUsePortal = true;

      # GTK 处理文件选择 / OpenURI
      # GNOME 处理 Wayland 屏幕共享（Zoom / OBS / Discord 视频会议必须）
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];

      # 默认走 gtk，gtk 不能处理的（比如 ScreenCast）回落到 gnome
      config.common.default = [ "gtk" "gnome" ];
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
