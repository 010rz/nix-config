{ lib, config, ... }:
let
  cfg = config.modules.services.daed;
in
{
  options.modules.services.daed.enable =
    lib.mkEnableOption "daed: dae 的 Web UI 透明代理 (Linux 内核 eBPF)";

  # ============================================================================
  # daed 启用后:
  #   1. 浏览器访问 http://localhost:2023 设管理员账号
  #   2. 在 Web UI 里加节点订阅、配路由规则、Apply
  #   3. 系统级流量被透明代理 (不用每个应用单独设 SOCKS5/HTTP_PROXY)
  #
  # 性能：dae 跑在内核 eBPF，比 clash-verge 这种 userspace 代理 CPU 占用低一个量级
  # 文档: https://github.com/daeuniverse/dae
  # ============================================================================
  config = lib.mkIf cfg.enable {
    services.daed = {
      enable = true;
      # openFirewall 默认就是关的，不显式写
      # 想从局域网/平板访问 Web UI 时再加 openFirewall.{port,...} (它是 submodule 不是 bool)
    };
  };
}
