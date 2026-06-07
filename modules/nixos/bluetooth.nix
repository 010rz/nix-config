{
  # Bluetooth daemon (BlueZ)
  # dms-shell 自带的蓝牙 panel 通过 DBus 跟 BlueZ 通信，所以不需要 blueman GUI
  # 命令行兜底：bluetoothctl → scan on → pair / connect / trust
  hardware.bluetooth.enable = true;

  # 蓝牙音频自动走 pipewire (我们已经启用)，wireplumber 负责 A2DP/HFP 后端
}
