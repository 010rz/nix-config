{ lib, config, ... }:
let
  cfg = config.modules.desktop.wayland;
in
{
  config = lib.mkIf cfg.enable {
    # X11 server 仍需启用（NVIDIA + xserver.videoDrivers 配置依赖它）
    services.xserver.enable = true;

    # 用 GDM 作为登录管理器（Wayland 友好，精致 UI）
    # 之前试过 greetd+regreet (PAM AUTH_ERR) 和 SDDM (没成功)，回 GDM 最稳
    services.displayManager.gdm.enable = true;
  };
}
