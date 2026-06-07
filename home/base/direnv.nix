{
  # direnv：项目级环境变量，进目录自动 source .envrc，离开自动 unset
  # 不同项目可以用不同 PATH / API key / nix shell，互不污染
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    # nix-direnv: .envrc 里写 `use flake` 自动激活 nix 开发环境（编译器 / LSP 等）
    nix-direnv.enable = true;
  };
}
