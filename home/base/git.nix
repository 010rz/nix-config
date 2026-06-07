{ myvars, ... }:
{
  programs.git = {
    enable = true;

    # HM 26.05 起 userName/userEmail/extraConfig 合并到统一的 settings 树
    settings = {
      user.name = myvars.gitName;
      user.email = myvars.gitEmail;

      init.defaultBranch = "main";
      pull.rebase = false;

      # 第一次 push 自动建立 remote tracking，不用每次敲 `git push -u origin main`
      push.autoSetupRemote = true;
    };
  };
}
