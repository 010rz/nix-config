{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.fcitx5;

  # rime-ice (雾凇拼音) —— 维护活跃，覆盖网络用语 / ACG / 专业词汇
  # https://github.com/iDvel/rime-ice
  rime-ice-src = pkgs.fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "f75919b69a06b2f81b84a991028acdf05dc5ec75";
    hash = "sha256-/EQMUkmTZAG0t7sLA3/GrnrS3RE6ouwjMsyOf/h0yuc=";
  };

  # 把裸仓库包装成 fcitx5-rime 期望的 share/rime-data 布局
  rime-ice = pkgs.runCommand "rime-ice" { } ''
    mkdir -p $out/share/rime-data
    cp -r ${rime-ice-src}/* $out/share/rime-data/
  '';
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
          # 用自定义 rime-data 覆盖默认：rime-ice 优先 > rime-data 兜底
          (fcitx5-rime.override { rimeDataPkgs = [ rime-data rime-ice ]; })
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
