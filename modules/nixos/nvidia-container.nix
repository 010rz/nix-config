{ lib, config, ... }:
let
  cfg = config.modules.hardware.nvidia-container;
in
{
  options.modules.hardware.nvidia-container.enable =
    lib.mkEnableOption "NVIDIA Container Toolkit (docker/podman GPU passthrough)";

  config = lib.mkIf cfg.enable {
    # 启用后 docker run --gpus all / podman --device nvidia.com/gpu=all 能直通 dGPU
    # 没装 docker/podman 时这条没副作用，只是把运行时备好
    hardware.nvidia-container-toolkit.enable = true;
  };
}
