{ myvars, ... }:
{
  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  # 与 system.stateVersion 同步；初次设定后不要改
  home.stateVersion = myvars.stateVersion;

  programs.home-manager.enable = true;
}
