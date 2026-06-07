{
  programs.gh = {
    enable = true;
    # 让 git 通过 gh 走认证：`gh auth login` 一次后，`git push` over HTTPS 自动用同一份凭证
    gitCredentialHelper.enable = true;
  };
}
