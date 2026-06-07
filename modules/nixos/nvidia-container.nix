{ lib, config, myvars, ... }:
let
  cfg = config.modules.hardware.nvidia-container;
in
{
  options.modules.hardware.nvidia-container.enable =
    lib.mkEnableOption "NVIDIA Container Toolkit + docker + CDI for GPU containers";

  config = lib.mkIf cfg.enable {
    # 1) NVIDIA Container Toolkit
    # 后台用 nvidia-ctk 生成 /etc/cdi 下的 CDI 规格，不暴露给用户 PATH
    hardware.nvidia-container-toolkit.enable = true;

    # 2) Docker daemon
    # 官方 wiki: https://wiki.nixos.org/wiki/Docker
    virtualisation.docker = {
      enable = true;

      # btrfs 上要用 btrfs 驱动 (你 / 是 btrfs)，否则 docker 在 overlay2 上跑会降级
      storageDriver = "btrfs";

      # 定期清理悬挂镜像/容器/网络，防止 /nix 外的 /var/lib/docker 撑爆磁盘
      autoPrune = {
        enable = true;
        dates = "weekly";
      };

      daemon.settings = {
        # 开 CDI 特性，nvidia-container-toolkit 通过 CDI 接入 docker
        features.cdi = true;
        # 容器日志走 systemd-journald，可以用 journalctl 统一查
        log-driver = "journald";
      };
    };

    # 3) 把用户加入 docker 组
    # ⚠️ wiki 警告: "docker group membership is effectively equivalent to being root"
    # 因为 docker daemon 跑在 root，组成员能通过它启动特权容器逃逸
    # 单用户笔电可接受；多用户/服务器场景考虑 rootless docker 或 podman
    users.users.${myvars.username}.extraGroups = [ "docker" ];
  };

  # 用法:
  #   docker run --rm --device=nvidia.com/gpu=all \
  #     nvidia/cuda:12.6.0-base-ubuntu24.04 nvidia-smi
  #
  # 改 extraGroups 后必须重登一次 niri (新 shell 才有 docker 组身份)
}
