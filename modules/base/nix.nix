{
  # 系统通用的 nix 设置；nixos/darwin 共享
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # 信任 wheel 组的用户，避免远程构建/沙箱权限问题
    trusted-users = [ "@wheel" ];

    # binary cache 服务器，按顺序尝试。失败自动 fallback 到下一个。
    # nix 用密码学签名验证内容，镜像无法塞坏文件，纯纯只省下载时间。
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"           # 中科大 镜像 (国内首选)
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清华 TUNA 镜像 (国内备份)
      "https://nix-community.cachix.org"                         # 社区 cache (大量 flake 包预编)
      "https://cache.nixos.org/"                                 # 官方兜底
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # USTC / TUNA 是官方 cache 的纯镜像，复用官方 key 即可
    ];
    # 远程构建器也走我们的 substituter (现在没用远程构建，留着不亏)
    builders-use-substitutes = true;
  };

  nixpkgs.config.allowUnfree = true;
}
