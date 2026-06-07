{ myvars, ... }:
{
  programs.git = {
    enable = true;
    userName = myvars.userfullname;
    userEmail = myvars.useremail;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
