{ lib, config, ... }:
let
  cfg = config.modules.services.sunshine;
in
{
  options.modules.services.sunshine.enable =
    lib.mkEnableOption "Sunshine 游戏 / 桌面串流服务器（Moonlight 协议）";

  # ============================================================================
  # 用法：
  #   1. 启用后访问 https://localhost:47990/ 在 Web UI 设管理员账号
  #   2. 别的设备装 moonlight 客户端连过来
  # 检查：systemctl --user status sunshine | journalctl --user -u sunshine
  # 文档：https://docs.lizardbyte.dev/projects/sunshine/latest/index.html
  # ============================================================================
  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;       # Wayland 屏幕捕获需要 CAP_SYS_ADMIN
      openFirewall = true;
      settings = {
        # Web UI 访问范围：pc=只本机；lan=同局域网；wan=公网
        origin_web_ui_allowed = "pc";
        # 加密：2 = 强制；1 = 优先；0 = 关
        lan_encryption_mode = 2;
        wan_encryption_mode = 2;

        # NVENC 调优（你的 RTX 5080 Max-Q 跑得起更高码率）
        max_bitrate = 20000;        # Kbps
        nvenc_preset = 3;           # 1 最快/最差 — 7 最慢/最好
        nvenc_twopass = "full_res"; # full_res / quarter_res
      };
    };
  };
}
