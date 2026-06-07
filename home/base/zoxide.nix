{
  # zoxide：记录 cd 历史 + 频次，`z 部分关键字` 直接跳常去的目录
  # 例：访问过 ~/nix-config 几次后，`z nix` 自动跳进去
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    # 命令：z (智能 cd) 和 zi (交互式 fzf 选)
  };
}
