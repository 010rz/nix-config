{ lib, config, myvars, ... }:
let
  cfg = config.modules.virtualisation;
in
{
  options.modules.virtualisation.enable =
    lib.mkEnableOption "KVM 嵌套虚拟化 + libvirt/qemu + virt-manager";

  config = lib.mkIf cfg.enable {
    # 1) 嵌套虚拟化 (Intel)
    # 你的 CPU 是 Arrow Lake-HX，用 kvm_intel
    # 官方 wiki: https://wiki.nixos.org/wiki/Libvirt
    boot.extraModprobeConfig = ''
      options kvm_intel nested=1
    '';

    # 2) libvirt daemon + qemu
    virtualisation.libvirtd.enable = true;
    # 想跑 Win11 客户机时再加: virtualisation.libvirtd.qemu.swtpm.enable = true;

    # 3) virt-manager 图形管理 (libvirt 的标准 GUI)
    programs.virt-manager.enable = true;

    # 4) 用户加入 libvirtd 组 (跟 modules/nixos/users.nix 的 extraGroups 合并)
    users.users.${myvars.username}.extraGroups = [ "libvirtd" ];
  };

  # 验证 nested 是否生效（要重启后才能查）:
  #   cat /sys/module/kvm_intel/parameters/nested
  #   返回 Y = 嵌套已启用
  # virt-manager 在 Niri 启动器里搜索 "Virtual Machine Manager" 打开
}
