{ lib, config, ... }:
let
  cfg = config.modules.hardware.nvidia-container;
in
{
  options.modules.hardware.nvidia-container.enable =
    lib.mkEnableOption "NVIDIA Container Toolkit + Podman + CDI for GPU containers";

  config = lib.mkIf cfg.enable {
    # 1) NVIDIA Container Toolkit
    # 自动生成 /etc/cdi/nvidia.json，CDI 是通用接口、docker 和 podman 都读
    hardware.nvidia-container-toolkit.enable = true;

    # 2) Podman 替代 docker —— 无 daemon、可 rootless、无 docker 组 = root 风险
    # 官方 wiki: https://wiki.nixos.org/wiki/Podman
    virtualisation.podman = {
      enable = true;

      # `docker` 命令变成 podman 的符号链接
      # 现有 docker 文档/脚本/docker-compose 大多数能直接复用
      dockerCompat = true;

      # 默认网络启用 DNS，容器之间可以用名字互相访问
      defaultNetwork.settings.dns_enabled = true;

      # 每周清一次未引用的 image / volume / network
      # 防止长期累积撑爆 /var/lib/containers
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };
  };

  # 用法 (podman 原生读 /etc/cdi，跟 docker CDI 语法一致):
  #   podman run --rm --device=nvidia.com/gpu=all \
  #     nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi
  #
  # 因为 dockerCompat = true，下面这条等价，跑的还是 podman:
  #   docker run --rm --device=nvidia.com/gpu=all <image> ...
}
