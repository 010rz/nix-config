{ lib, config, pkgs, ... }:
let
  cfg = config.modules.services.clash-verge;
in
{
  options.modules.services.clash-verge.enable =
    lib.mkEnableOption "Clash Verge Rev (维护版 Tauri 客户端，原 clash-verge 已归档)";

  config = lib.mkIf cfg.enable {
    programs.clash-verge = {
      enable = true;
      # nixpkgs 里 programs.clash-verge 这个 module 的默认 package 是原 clash-verge
      # 这里换成活跃维护的 rev 分支
      package = pkgs.clash-verge-rev;

      # 不开机自启，自己在 Niri 启动器开
      autoStart = false;
      # serviceMode: 后台 daemon 模式，不会因 GUI 关闭而断代理
      serviceMode = true;
      # TUN mode: 系统级劫持流量到代理，比 HTTP/SOCKS 全局代理彻底
      tunMode = true;
    };
  };

  # 启动：Niri 启动器搜 "Clash Verge"
  # 配置：拖入订阅 URL → 选节点 → 打开 TUN/系统代理开关
}
