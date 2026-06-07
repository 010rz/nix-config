{ pkgs, ... }:
{
  # Papirus 图标主题 (Linux 桌面最通用)
  home.packages = with pkgs; [
    papirus-icon-theme
    # 鼠标光标主题 (顺手装个统一风格的)
    bibata-cursors
  ];

  # GTK 设置 (dms-shell / GTK 应用 / Niri 弹窗都读)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";       # 也有 "Papirus" / "Papirus-Light" 变体
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  # Wayland 鼠标光标 (XWayland / Niri 也读这套)
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
