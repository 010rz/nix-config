{
  description = "test's NixOS configuration";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    # nixos-26.05 stable channel：和你装机时一致，内核/驱动 binding 已验证可用
    # 用 unstable 时 (commit 331800d/2026-05-31) 内核 7.0.10 在 MSI Titan 16 AI 上无法启动 display
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      # 必须跟 nixpkgs 大版本对齐：nixpkgs 是 nixos-26.05，HM 用 release-26.05
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 文件树自动加载器（ryan4yin 用它在 outputs/ 下按目录懒加载 host 定义）
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # dae / daed 透明代理 (Linux 内核 eBPF) 官方 flake
    daeuniverse.url = "github:daeuniverse/flake.nix";
  };
}
