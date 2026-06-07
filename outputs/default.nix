{
  self,
  nixpkgs,
  ...
}@inputs:
let
  inherit (inputs.nixpkgs) lib;

  # 自研工具与变量集（ryan4yin 风格）
  mylib = import ../lib { inherit lib; };
  myvars = import ../vars { inherit lib; };

  # 把 inputs + mylib + myvars 注入到所有 nixos 与 home-manager 模块的 args 里。
  # 模块写 `{ myvars, mylib, ... }:` 就能直接访问。
  genSpecialArgs = system:
    inputs
    // {
      inherit mylib myvars;
    };

  # 这是 outputs/<arch>/default.nix 接收的参数
  args = {
    inherit inputs lib mylib myvars genSpecialArgs;
  };

  # 按架构分发；目前只有一台 x86_64-linux
  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
  };

  allSystemNames = builtins.attrNames nixosSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;

  forAllSystems = func: lib.genAttrs allSystemNames func;
in
{
  # 把每个架构下的 nixosConfigurations 合并到顶层
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  # `nix fmt` 会用这个格式化器
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
}
