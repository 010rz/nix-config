{ lib, config, ... }:
let
  cfg = config.modules.desktop.wayland;
in
{
  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true; # 需要 JACK 应用再开
    };
  };
}
