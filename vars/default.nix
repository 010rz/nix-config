{ lib, ... }:
{
  # ---- Linux 用户身份（GDM / 系统层显示）----
  username = "test";
  userfullname = "test";  # users.users.<name>.description；GDM 登录界面读这个

  # ---- Git / GitHub 身份（仅 commit 作者用，不影响系统）----
  gitName = "010rz";
  # GitHub no-reply 邮箱: <userid>+<login>@users.noreply.github.com
  # commit 仍然归属到 GitHub 账号，但不暴露真邮箱
  gitEmail = "274207583+010rz@users.noreply.github.com";

  hostname = "nixos";
  timezone = "Asia/Shanghai";
  locale = "zh_CN.UTF-8";

  # NixOS 初装时确定的 stateVersion，不要随便改
  stateVersion = "26.05";
}
