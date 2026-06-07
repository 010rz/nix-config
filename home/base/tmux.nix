{
  programs.tmux = {
    enable = true;

    # vi 模式：复制 / 选择走 vim 键位 (按 prefix + [ 进入，hjkl 移动)
    keyMode = "vi";

    # 鼠标支持：滚轮翻历史、点击切窗口
    mouse = true;

    # 256 色 + true color 支持
    terminal = "tmux-256color";

    # esc 不延迟 (默认 500ms，vim 里按 Esc 会卡顿一下)
    escapeTime = 0;

    # 历史保留 10w 行
    historyLimit = 100000;

    # 窗口编号从 1 开始 (默认 0，但键盘 1 比 0 顺手)
    baseIndex = 1;

    # 不动 prefix (默认 C-b)，保留 C-a 给 bash readline 行首
  };
}
