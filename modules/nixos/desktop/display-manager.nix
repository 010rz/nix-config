{ lib, config, pkgs, ... }:
let
  cfg = config.modules.desktop.wayland;
in
{
  config = lib.mkIf cfg.enable {
    # X11 server 仍需启用（NVIDIA + xserver.videoDrivers 配置依赖它）
    services.xserver.enable = true;

    # 砍 gdm + greetd（之前的几次尝试）
    services.displayManager.gdm.enable = lib.mkForce false;
    services.greetd.enable = lib.mkForce false;
    programs.regreet.enable = lib.mkForce false;

    # ============================================================================
    # SDDM with sddm-astronaut theme
    # 长相：QML + Qt6, 带视频/SVG 背景, 头像, 时钟, 多 layout
    # 主题切 variant: ${sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme/Themes/
    # 在 metadata.desktop 改 ConfigFile 指向你想要的 .conf
    # ============================================================================
    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;          # Qt6 版本（旧 Qt5 版本带不动新主题）
      wayland.enable = true;                    # 让 Niri 这种 Wayland session 能列出来
      theme = "sddm-astronaut-theme";
    };

    # 主题包 + Qt6 运行时依赖（视频背景 / 输入法切换 / SVG）
    environment.systemPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
    ];
  };
}
