{ pkgs, ... }:
{
  # MSI Titan 16 AI 启动时把所有无线 (WiFi + 蓝牙) 默认 soft-block
  # 跑一次 `rfkill unblock all` 在登录前清空 block 状态
  # 比单独配 bluetooth.powerOnBoot 更彻底，也覆盖以后插的新无线设备 (USB 蓝牙、5G 模块等)
  systemd.services.rfkill-unblock-all = {
    description = "Unblock all rfkill switches at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-rfkill.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock all";
      RemainAfterExit = true;
    };
  };
}
