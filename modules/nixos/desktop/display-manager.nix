{ lib, config, ... }:
let
  cfg = config.modules.desktop.wayland;
in
{
  config = lib.mkIf cfg.enable {
    # X11 server 仍需启用（NVIDIA + xserver.videoDrivers 配置依赖它）
    services.xserver.enable = true;

    # 用 gdm 作为登录管理器（Wayland 友好）
    services.displayManager.gdm.enable = true;
  };
}
