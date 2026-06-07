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

  # 有线网卡 enp131s0 (Realtek 2.5G) 静态地址 —— 走 NetworkManager 声明式 profile
  # 改 IP / 网关 / DNS 直接改这块即可
  networking.networkmanager.ensureProfiles.profiles."wired-static" = {
    connection = {
      id = "wired-static";
      type = "ethernet";
      interface-name = "enp131s0";
      autoconnect = true;
    };
    ipv4 = {
      method = "manual";
      address1 = "192.168.100.188/24,192.168.100.1";
      # DNS: 网关 + Cloudflare 兜底；用分号分隔，末尾留分号
      dns = "192.168.100.1;1.1.1.1;";
    };
    ipv6.method = "auto";
  };

  # 初装时定下的 stateVersion，不要随便改
  system.stateVersion = myvars.stateVersion;
}
