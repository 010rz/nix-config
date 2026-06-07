{ pkgs, ... }:
{
  # OBS Studio：录屏 / 直播 / 视频会议虚拟摄像头
  # 必须用 programs.obs-studio (而不是 home.packages) 才能把插件 wrap 进 binary
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # 按应用 (per-window) 抓音频，比抓整个 sink 干净
      # 比如游戏音 + 不抓语音通话
      obs-pipewire-audio-capture

      # Vulkan / OpenGL 游戏画面捕获
      # Wayland 上比 xcomposite 强得多，性能损失小
      obs-vkcapture
    ];
  };
}
