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
        # 上游模块（来自 flake input）
        inputs.daeuniverse.nixosModules.daed
      ]
      ++ [
        # 在这里开启这台机器需要的模块
        {
          modules.desktop.wayland.enable = true;
          modules.desktop.fonts.enable = true;
          modules.desktop.fcitx5.enable = true;
          modules.desktop.printing.enable = true;
          modules.desktop.gaming.enable = true;
          modules.hardware.nvidia-prime.enable = true;
          modules.hardware.nvidia-container.enable = true;
          modules.virtualisation.enable = true;
          # 想串流游戏时把下行的 # 去掉
          # modules.services.sunshine.enable = true;
          modules.services.daed.enable = true;
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
