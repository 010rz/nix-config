{ lib, config, pkgs, nix-gaming, ... }:
let
  cfg = config.modules.desktop.gaming;
in
{
  # 引入 nix-gaming 的两个 NixOS 模块（option 定义无副作用，下面再具体开关）
  imports = [
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations
  ];

  options.modules.desktop.gaming.enable =
    lib.mkEnableOption "Gaming stack (Steam + GameMode + Gamescope + nix-gaming 优化)";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;

      # Gamescope 微合成器作为登录会话；GDM 里会多出 "Steam (gamescope)" 选项
      # 修 Wayland 上分辨率拉伸 / 刷新率切换不正常
      gamescopeSession.enable = true;

      # Steam Input (手柄 / 陀螺仪 / Steam Deck 风格) 在 Wayland 上的兼容垫片
      extest.enable = true;

      # Winetricks 的 Proton 包装，修单个游戏的 DXVK / 字体 / .NET 问题
      protontricks.enable = true;

      # Steam UI 中文显示，不加全是方块
      fontPackages = [ pkgs.wqy_zenhei ];

      # 远程串流（Steam Link）和专用服务器自动开防火墙端口
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;

      # nix-gaming 提供：内核 / sched / lock 等针对游戏的微调
      platformOptimizations.enable = true;
    };

    # nix-gaming 提供：把 PipeWire quantum 降到 64 帧，缩短音频延迟（VR / 节奏游戏明显）
    services.pipewire.lowLatency.enable = true;

    # Feral GameMode：跑游戏时 CPU 切 performance、I/O 优先级提升、后台进程降优先级
    # Steam / Lutris / 主流启动器自动调用 (gamemoderun 启动游戏)
    programs.gamemode.enable = true;
  };
}
