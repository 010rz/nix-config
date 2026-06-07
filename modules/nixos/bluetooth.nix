{
  # Bluetooth daemon (BlueZ)
  hardware.bluetooth.enable = true;

  # blueman: GUI 配对/管理 (blueman-applet 出系统托盘图标，blueman-manager 出独立窗口)
  # 命令行也可以：bluetoothctl → scan on / pair / connect
  services.blueman.enable = true;

  # 蓝牙音频走 pipewire (我们已经启用了 pipewire)，pipewire 会自动拉蓝牙后端 wireplumber
}
