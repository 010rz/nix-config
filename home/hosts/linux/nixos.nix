{ mylib, ... }:
{
  # 单台机器的 home-manager 入口：把跨平台的 base 和 Linux 专属配置拉进来。
  # 以后这台机器有专属的 home 配置时再加到这个文件里。
  imports = map mylib.relativeToRoot [
    "home/base"
    "home/linux"
  ];
}
