{ myvars, ... }:
{
  users.users."${myvars.username}" = {
    isNormalUser = true;
    description = myvars.userfullname;
    extraGroups = [ "networkmanager" "wheel" ];
    # 用户级软件包都在 home-manager 里管理，这里不再列
  };
}
