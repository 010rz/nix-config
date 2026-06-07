{ lib, config, ... }:
let
  cfg = config.modules.desktop.printing;
in
{
  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
