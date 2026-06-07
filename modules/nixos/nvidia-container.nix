{ lib, config, myvars, ... }:
let
  cfg = config.modules.hardware.nvidia-container;
in
{
  options.modules.hardware.nvidia-container.enable =
    lib.mkEnableOption "NVIDIA Container Toolkit + docker + CDI for GPU containers";

  config = lib.mkIf cfg.enable {
    # 1) 装 NVIDIA Container Toolkit (nvidia-ctk 在后台生成 CDI 规格，不暴露给用户 PATH)
    hardware.nvidia-container-toolkit.enable = true;

    # 2) 起 docker daemon 并开 CDI 特性 (官方 wiki: https://wiki.nixos.org/wiki/Docker)
    virtualisation.docker = {
      enable = true;
      daemon.settings.features.cdi = true;
    };

    # 3) 把 test 用户加入 docker 组，可不 sudo 直接跑 docker
    # 跟 modules/nixos/users.nix 里的 extraGroups 自动合并
    users.users.${myvars.username}.extraGroups = [ "docker" ];
  };

  # 用法：
  #   docker run --rm --device=nvidia.com/gpu=all nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi
  # 容器内能看到 RTX 5080 = 配置成功
}
