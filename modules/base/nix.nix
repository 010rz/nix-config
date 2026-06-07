{
  # 系统通用的 nix 设置；nixos/darwin 共享
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # 信任 wheel 组的用户，避免远程构建/沙箱权限问题
    trusted-users = [ "@wheel" ];
  };

  nixpkgs.config.allowUnfree = true;
}
