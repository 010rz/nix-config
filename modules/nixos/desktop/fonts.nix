{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.fonts;
in
{
  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      # 通用 + 中日韩
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      # 等宽 + Nerd Font 图标，给终端 / 编辑器
      nerd-fonts.jetbrains-mono
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" "Noto Serif" ];
        sansSerif = [ "Noto Sans CJK SC" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
