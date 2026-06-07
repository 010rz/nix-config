{
  networking.networkmanager.enable = true;
  # hostName 在 hosts/<name>/default.nix 里设置

  # mDNS / Avahi —— 让局域网设备能用 `xxx.local` 互相找
  # 你 ping 路由器 `router.local`、连打印机 `printer.local` 都靠这个
  services.avahi = {
    enable = true;
    nssmdns4 = true;        # 把 .local 加进 nsswitch.conf，普通程序也能解析
    openFirewall = true;    # 开 5353/udp 让别人能 discover 这台
  };
}
