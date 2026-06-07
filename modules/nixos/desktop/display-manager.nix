{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.wayland;
in
{
  config = lib.mkIf cfg.enable {
    # X11 server 仍需启用（NVIDIA + xserver.videoDrivers 配置依赖它）
    services.xserver.enable = true;

    # 关掉 gdm 和之前实验失败的 regreet
    services.displayManager.gdm.enable = lib.mkForce false;
    # programs.regreet.enable 不写就是 false (regreet 跟 NixOS 26.05 PAM 模块有兼容 bug)

    # greetd + tuigreet (TTY 风文字登录，跟 PAM 集成稳定)
    # 进登录界面输用户名 + 密码，然后自动跳进 niri-session
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd niri-session";
          user = "greeter";
        };
      };
    };
  };
}
