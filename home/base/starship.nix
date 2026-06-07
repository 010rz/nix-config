{
  # Starship：Rust 写的 prompt，自动显示 git branch / dirty / nix shell / k8s ctx 等
  # 进入 git 仓库立刻看到分支名 + 是否有未提交改动
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    # 默认配置已经足够好；要自定义改 settings 块
  };
}
