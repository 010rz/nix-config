{ pkgs, ... }:
{
  # 用户级 CLI / TUI 工具
  home.packages = with pkgs; [
    claude-code
  ];
}
