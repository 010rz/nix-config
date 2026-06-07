{ lib, config, ... }:
let
  cfg = config.modules.desktop.wayland;
in
{
  config = lib.mkIf cfg.enable {
    # X11 server 仍需启用（NVIDIA + xserver.videoDrivers 配置依赖它）
    services.xserver.enable = true;

    # 关掉 gdm，省 ~150 MB GNOME runtime
    services.displayManager.gdm.enable = lib.mkForce false;

    # greetd + regreet：轻量 GTK 登录界面，外观接近 GDM
    # 内部跑在 cage (kiosk Wayland 合成器)，跟 Niri 会话隔离
    programs.regreet.enable = true;
  };
}
