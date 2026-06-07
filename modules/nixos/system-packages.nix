{ pkgs, ... }:
{
  # 系统级软件包：只放系统服务/登录会话/恢复必备的
  environment.systemPackages = with pkgs; [
    vim                # 系统恢复时的兜底编辑器
    xwayland-satellite # Niri 启动 X11 兼容层时需要
    wl-clipboard       # 剪贴板工具，dms-shell 等系统组件可能引用
  ];
}
