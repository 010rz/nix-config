{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.fcitx5;
in
{
  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        # 启用官方 Wayland 前端，避免 GTK/Qt 环境变量警告
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-rime
          fcitx5-gtk
          kdePackages.fcitx5-configtool
        ];

        # 让 NixOS 接管输入法配置，不读 ~/.local/share/fcitx5
        ignoreUserConfig = true;

        # 声明式设默认输入法为 rime，键盘走 US 布局
        settings.inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
        };
      };
    };
  };
}
