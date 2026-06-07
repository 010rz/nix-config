{ mylib, ... }:
{
  imports = (mylib.scanPaths ./.) ++ [
    # 也把通用模块（与 darwin 共享的）拉进来
    ../base
  ];
}
