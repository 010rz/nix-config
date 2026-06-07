{
  # OpenSSH server: 让别的设备能 ssh 进这台
  # 允许密码登录 (单用户笔电 LAN-only 场景够用；要锁紧改 false 然后填 authorizedKeys)
  services.openssh = {
    enable = true;
    openFirewall = true;             # 防火墙放 tcp/22
    settings = {
      PermitRootLogin = "no";        # root 还是禁
      PasswordAuthentication = true; # 密码登录开 (用 test 账号系统密码)
    };
  };
}
