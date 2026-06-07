{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.fonts;
in
{
  config = lib.mkIf cfg.enable {
    fonts = {
      # 不要 nixpkgs 默认的字体集（很多用不上的），明确控制安装哪几个
      enableDefaultPackages = false;
      # 注册到 /nix/var/nix/profiles/system/sw/share/X11/fonts (X11 / 老程序能找到)
      fontDir.enable = true;

      packages = with pkgs; [
        # ===== 中日韩 =====
        source-han-sans     # 思源黑体 (Adobe + Google 联合开发)
        source-han-serif    # 思源宋体
        source-han-mono     # 思源等宽
        lxgw-wenkai-screen  # 霞鹜文楷 屏幕阅读版 (中文阅读神器)

        # ===== 等宽 (终端 / 编辑器) =====
        maple-mono.NF-CN-unhinted  # 中英 2:1 + Nerd Font + unhinted (2.5K 屏更锐利)
        nerd-fonts.jetbrains-mono  # 兜底，纯英文场景

        # ===== Emoji =====
        noto-fonts-color-emoji
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          # 西文衬线 + 中文宋体
          serif = [
            "Source Serif 4"
            "Source Han Serif SC"
            "Source Han Serif TC"
          ];
          # 西文无衬线 + 中文黑体 (霞鹜文楷优先用于阅读，思源做后备)
          sansSerif = [
            "Source Sans 3"
            "LXGW WenKai Screen"
            "Source Han Sans SC"
            "Source Han Sans TC"
          ];
          # 等宽：Maple Mono NF CN 中英 2:1 完美对齐，JetBrainsMono 兜底
          monospace = [
            "Maple Mono NF CN"
            "Source Han Mono SC"
            "JetBrainsMono Nerd Font"
          ];
          emoji = [ "Noto Color Emoji" ];
        };

        # ===== 渲染调优 (高分屏 IPS 优化) =====
        antialias = true;          # 抗锯齿
        hinting.enable = false;    # 高分屏关 hinting 更锐
        subpixel.rgba = "rgb";     # IPS 子像素排列 RGB
      };
    };
  };
}
