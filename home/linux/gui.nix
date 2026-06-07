{ pkgs, ... }:
{
  # 用户级桌面应用——这些走 ~/.nix-profile/bin，Niri 通过 PATH 能找到
  home.packages = with pkgs; [
    # 编辑器栈
    zed-editor
    nil          # Zed 的 Nix LSP
    nixpkgs-fmt  # Nix 代码格式化

    # 终端 & 启动器（Niri 默认 Super+T / Super+D）
    alacritty
    ghostty
    fuzzel
  ];
}
