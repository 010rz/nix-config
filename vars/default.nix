{ lib, ... }:
{
  username = "test";
  userfullname = "010rz";
  # GitHub no-reply 邮箱: <userid>+<login>@users.noreply.github.com
  # 用 no-reply 而非真实邮箱 = commit 仍然归属到 GitHub 账号，但不暴露真邮箱
  useremail = "274207583+010rz@users.noreply.github.com";

  hostname = "nixos";
  timezone = "Asia/Shanghai";
  locale = "zh_CN.UTF-8";

  # NixOS 初装时确定的 stateVersion，不要随便改
  stateVersion = "26.05";
}
