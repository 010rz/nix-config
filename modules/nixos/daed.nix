{ lib, config, ... }:
let
  cfg = config.modules.services.daed;
in
{
  options.modules.services.daed.enable =
    lib.mkEnableOption "daed (官方 docker 镜像 ghcr.io/daeuniverse/daed)";

  # ============================================================================
  # 走官方 OCI 镜像而不是 daeuniverse/flake.nix 的纯 nix 编译：
  #   - 绕开 daed-pnpm-deps 的 hash mismatch 问题
  #   - 拿到 1.24.0+ 最新版（nixpkgs 还停在 1.0.0 没人更新）
  #   - 声明式管理，跟我们 podman 系统集成
  #
  # 启用后：
  #   1. systemd 起 podman-daed.service 自动拉镜像 + 跑容器
  #   2. 浏览器开 http://localhost:2023 配账号 + 节点订阅
  #
  # 镜像参考 daed 官方 README：privileged + network=host + pid=host
  # 持久化挂 /etc/daed (节点订阅 / 路由规则 / DB)
  # ============================================================================
  config = lib.mkIf cfg.enable {
    # 容器要挂的 /etc/daed 目录在宿主上得先存在
    systemd.tmpfiles.rules = [
      "d /etc/daed 0700 root root - -"
    ];

    virtualisation.oci-containers = {
      backend = "podman"; # 跟我们已有的 podman 集成 (nvidia-container 那条线)
      containers.daed = {
        image = "ghcr.io/daeuniverse/daed:latest";
        # 想钉版本就把 :latest 改成具体 tag，例如 :v1.24.0
        autoStart = true;
        volumes = [
          "/sys:/sys"
          "/etc/daed:/etc/daed"
        ];
        extraOptions = [
          "--privileged"
          "--network=host" # 透明代理需要直接操作宿主网络栈
          "--pid=host"     # eBPF program 要看宿主进程 cgroup
        ];
      };
    };
  };
}
