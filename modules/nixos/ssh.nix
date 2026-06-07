{
  # OpenSSH server: 让别的设备能 ssh 进这台
  # 默认 key-only 登录 (禁密码 + 禁 root)
  services.openssh = {
    enable = true;
    openFirewall = true;             # 防火墙放 tcp/22
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;       # 必须 key
      KbdInteractiveAuthentication = false; # 禁键盘交互 (PAM 后备路径)
    };
  };

  # 当前 test 用户的 authorized_keys 在 modules/nixos/users.nix 里管：
  #   users.users.${myvars.username}.openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAA... 手机/平板 (Termius)"
  #     "ssh-ed25519 AAAA... 另一台 Linux 工作站"
  #   ];
  # 没填就没人能 SSH 进来（系统层 SSH server 在跑，但 0 个有效公钥 = 谁都进不来）
}
