{
  # 让 home-manager 接管 bash，starship / direnv / zoxide 的初始化才会被写进 ~/.bashrc
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}
