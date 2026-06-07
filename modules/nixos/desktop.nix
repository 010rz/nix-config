{ lib, ... }:
{
  imports = [ ./desktop ];

  # 这一组开关在 outputs/x86_64-linux/src/<host>.nix 里被打开
  options.modules.desktop = {
    wayland = {
      enable = lib.mkEnableOption "Wayland desktop stack (Niri, pipewire, gdm)";
    };
    fonts = {
      enable = lib.mkEnableOption "System fonts (CJK + Nerd Font)";
    };
    fcitx5 = {
      enable = lib.mkEnableOption "fcitx5 + rime input method";
    };
    printing = {
      enable = lib.mkEnableOption "CUPS printing";
    };
  };
}
