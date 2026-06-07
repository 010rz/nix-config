{
  # NVIDIA + Wayland 用户会话环境变量
  # 让 Wayland buffer / OpenGL / VA-API 都明确选 NVIDIA 路径
  # nvidia-vaapi-driver 已通过 services.xserver.videoDrivers = ["nvidia"] 自动装上
  home.sessionVariables = {
    # VA-API 视频解码走 NVIDIA NVDEC (浏览器/mpv 硬解)
    LIBVA_DRIVER_NAME = "nvidia";
    # OpenGL Vendor Neutral Dispatch 明确选 NVIDIA 实现
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # nvidia-vaapi-driver 用 direct 模式，跳过 EGL 中转
    NVD_BACKEND = "direct";
    # Wayland compositor 创建图形缓冲走 nvidia-drm，Niri 在 NVIDIA 上更稳
    GBM_BACKEND = "nvidia-drm";
  };
}
