{ pkgs, ... }:
{
  # systemd-boot UEFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 跟随主线最新内核（NVIDIA open 模块通常要求较新内核）
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 加密交换分区（初装时 hardware-configuration.nix 没替我们写，这里补上）
  boot.initrd.luks.devices."luks-8a48b98d-0e8c-4a08-b279-9fe75016b43f".device =
    "/dev/disk/by-uuid/8a48b98d-0e8c-4a08-b279-9fe75016b43f";
}
