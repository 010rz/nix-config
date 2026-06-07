{
  # X11 键盘布局，Wayland compositor（Niri）通过 XKB_DEFAULT_* 也继承这个
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };
}
