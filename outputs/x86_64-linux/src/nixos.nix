{
  # haumea 是惰性求值的，未使用的 args 也不能省，否则它们对应的子节点不会被加载
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  ...
}@args:
let
  hostName = myvars.hostname; # "nixos"

  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "modules/nixos"
        "hosts/${hostName}"
      ])
      ++ [
        # 在这里开启这台机器需要的模块
        {
          modules.desktop.wayland.enable = true;
          modules.desktop.fonts.enable = true;
          modules.desktop.fcitx5.enable = true;
          modules.desktop.printing.enable = true;
          modules.desktop.gaming.enable = true;
          modules.hardware.nvidia-prime.enable = true;
        }
      ];

    home-modules = map mylib.relativeToRoot [
      "home/hosts/linux/${hostName}.nix"
    ];
  };
in
{
  nixosConfigurations = {
    "${hostName}" = mylib.nixosSystem (modules // args);
  };
}
