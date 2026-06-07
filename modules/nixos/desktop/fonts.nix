{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.fonts;
in
{
  config = lib.mkIf cfg.enable {
    fonts = {
      # 不要 nixpkgs 默认字体集
      enableDefaultPackages = false;
      fontDir.enable = true;

      # 单字体策略：Maple Mono NF CN unhinted 担当所有文本
      # 覆盖：拉丁、CJK (2:1 宽度)、编程合字、Nerd Font 单色图标
      # + Noto Color Emoji 单独负责彩色 emoji (😀 🎉 ❤️)
      # 两个字体相安无事：fontconfig 只在 emoji unicode 范围用 Noto
      packages = with pkgs; [
        maple-mono.NF-CN-unhinted
        noto-fonts-color-emoji
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          # serif / sans-serif / monospace 全部解析到同一个字体
          # 网页正文也会显示成等宽 (罕见但视觉上极统一)
          serif = [ "Maple Mono NF CN" ];
          sansSerif = [ "Maple Mono NF CN" ];
          monospace = [ "Maple Mono NF CN" ];
          emoji = [ "Noto Color Emoji" ];
        };

        # 高分屏渲染调优
        antialias = true;
        hinting.enable = false;
        subpixel.rgba = "rgb";
      };
    };
  };
}
