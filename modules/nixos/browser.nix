{
  # 用 programs.firefox 而不是 environment.systemPackages，因为它会加 wrapper 解决一些 Wayland/portals 集成问题
  programs.firefox.enable = true;
}
