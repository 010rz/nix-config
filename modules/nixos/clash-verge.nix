{ lib, config, ... }:
let
  cfg = config.modules.services.clash-verge;
in
{
  options.modules.services.clash-verge.enable =
    lib.mkEnableOption "Clash Verge Rev (维护版 Tauri 客户端)";

  # programs.clash-verge 这个 option 名留着兼容，默认 package 已经是 clash-verge-rev
  # (原 clash-verge 归档后 nixpkgs 把 package 切到 rev 分支了，2.4.7)
  config = lib.mkIf cfg.enable {
    programs.clash-verge = {
      enable = true;
      autoStart = false;   # 不开机自启，自己在 Niri 启动器开
      serviceMode = true;  # 后台 daemon 模式，关 GUI 代理不断
      tunMode = true;      # TUN 模式系统级劫持流量
    };
  };
}
