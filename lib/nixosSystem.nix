{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [ ],
  specialArgs ? (genSpecialArgs system),
  myvars,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager;
in
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;
  modules =
    nixos-modules
    ++ (lib.optionals ((lib.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # home-manager 接管已有 dotfile 时不抛错，备份成 *.hm.backup
        home-manager.backupFileExtension = "hm.backup";
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${myvars.username}".imports = home-modules;
      }
    ]);
}
