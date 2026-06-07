{ lib, config, ... }:
let
  cfg = config.modules.desktop.gaming;
in
{
  options.modules.desktop.gaming.enable = lib.mkEnableOption "Gaming stack (Steam)";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
