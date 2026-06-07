{ myvars, ... }:
{
  users.users."${myvars.username}" = {
    isNormalUser = true;
    description = myvars.userfullname;
    extraGroups = [ "networkmanager" "wheel" ];
    # 用户级软件包都在 home-manager 里管理，这里不再列
  };

  # wheel 组 sudo 免密
  # 单用户笔电 + LUKS 全盘加密 + 锁屏的场景：风险已经被前面挡住
  # 多用户 / 服务器场景应该改用 security.sudo.extraRules 只放具体命令
  security.sudo.wheelNeedsPassword = false;
}
