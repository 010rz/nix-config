{ myvars, ... }:
##############################################
#
#  nixos —— Intel + NVIDIA Optimus 笔记本
#
##############################################
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = myvars.hostname;

  # 初装时定下的 stateVersion，不要随便改
  system.stateVersion = myvars.stateVersion;
}
