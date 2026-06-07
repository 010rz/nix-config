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
          # fcitx5 官方中文输入法套件：全拼 + 双拼 + 五笔 + 仓颉
          # 内置 cloud-pinyin 模块，敲不出的新词从云端 (谷歌 / 百度) 拉
          # 跟 rime 比：少了 YAML 自定义自由，多了开箱即用 + 永远跟得上网络新词
          fcitx5-chinese-addons
          fcitx5-gtk
          kdePackages.fcitx5-configtool
        ];

        # 让 NixOS 接管输入法配置，不读 ~/.local/share/fcitx5
        ignoreUserConfig = true;

        # 声明式默认输入法为 pinyin (fcitx5-chinese-addons 的全拼引擎)
        settings.inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "pinyin";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "pinyin";
        };
      };
    };
  };
}
