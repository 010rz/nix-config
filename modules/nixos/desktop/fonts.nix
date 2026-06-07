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

      # 单字体策略：Maple Mono NF CN unhinted 一个打天下
      # 覆盖：拉丁、CJK (2:1 宽度)、编程合字、Nerd Font 图标
      # 不覆盖：彩色 emoji (浏览器/聊天里 emoji 会显示成方框或单色后备)
      packages = with pkgs; [
        maple-mono.NF-CN-unhinted
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          # serif / sans-serif / monospace 全部解析到同一个字体
          # 网页正文也会显示成等宽 (罕见但视觉上极统一)
          serif = [ "Maple Mono NF CN" ];
          sansSerif = [ "Maple Mono NF CN" ];
          monospace = [ "Maple Mono NF CN" ];
        };

        # 高分屏渲染调优
        antialias = true;
        hinting.enable = false;
        subpixel.rgba = "rgb";
      };
    };
  };
}
