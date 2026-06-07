{ lib, ... }:
{
  # 构造 NixOS 系统的封装器，注入 home-manager
  nixosSystem = import ./nixosSystem.nix;

  # 相对项目根路径，避免 ./../../.. 这种地狱路径
  relativeToRoot = lib.path.append ../.;

  # 扫描目录：返回目录里所有子目录 + 所有 .nix 文件（排除 default.nix）
  # 配合 `imports = mylib.scanPaths ./.;` 实现自动加载兄弟模块
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory")
          || (
            (path != "default.nix")
            && (lib.strings.hasSuffix ".nix" path)
          )
        ) (builtins.readDir path)
      )
    );
}
