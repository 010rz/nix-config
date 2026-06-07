{
  lib,
  inputs,
  ...
}@args:
let
  inherit (inputs) haumea;

  # 用 haumea 把 ./src 下每个 .nix 文件当成一个 host 加载。
  # 文件被惰性求值，访问到才执行。
  data = haumea.lib.load {
    src = ./src;
    inputs = args;
  };
  dataValues = builtins.attrValues data;
in
{
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) dataValues
  );
}
