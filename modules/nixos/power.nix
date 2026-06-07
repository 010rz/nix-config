{ ... }:
{
  # TuneD: Red Hat 出的现代电源/性能调度，替代 TLP 和 power-profiles-daemon
  # 内置多个 profile：balanced / performance / power-saver / latency-performance ...
  services.tuned = {
    enable = true;
    settings.dynamic_tuning = true; # 根据 CPU 负载动态调频
    ppdSupport = true;              # 模拟 power-profiles-daemon 的 DBus API，让 GNOME/KDE 电源 UI 可用
    ppdSettings.main.default = "balanced"; # balanced / performance / power-saver
  };

  # UPower: 电池状态 / 充放电事件 DBus，TuneD-ppd 依赖它
  services.upower.enable = true;

  # 显式关掉冲突的另外两个 daemon (NixOS 某些场景会默认拉起 PPD)
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;

  # 切 profile 命令：
  #   tuned-adm active                 # 看当前
  #   tuned-adm profile performance    # 切到性能档
  #   tuned-adm list                   # 看所有 profile
}
