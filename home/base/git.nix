{ myvars, ... }:
{
  programs.git = {
    enable = true;

    # HM 26.05 起 userName/userEmail/extraConfig 合并到统一的 settings 树
    settings = {
      user.name = myvars.userfullname;
      user.email = myvars.useremail;

      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
