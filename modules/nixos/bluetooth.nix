{
  # Bluetooth daemon (BlueZ)
  # dms-shell 自带的蓝牙 panel 通过 DBus 跟 BlueZ 通信，所以不需要 blueman GUI
  # 命令行兜底：bluetoothctl → scan on → pair / connect / trust
  hardware.bluetooth.enable = true;

  # MSI Titan 16 AI 默认 boot 时 rfkill 把 BT/WiFi soft-block
  # 这条让 BlueZ 启动时主动解 block 并 power on（手动跑 `rfkill unblock bluetooth` 等价）
  hardware.bluetooth.powerOnBoot = true;

  # 蓝牙音频自动走 pipewire (我们已经启用)，wireplumber 负责 A2DP/HFP 后端
}
