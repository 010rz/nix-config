{ pkgs, ... }:
{
  # 用户级 CLI / TUI 工具
  home.packages = with pkgs; [
    # AI / 编辑
    claude-code

    # 搜索 & 浏览 (现代版 find / grep)
    ripgrep         # rg —— 比 grep 快几十倍，自带 .gitignore 感知
    fd              # fd —— 比 find 简洁
    fzf             # 交互式模糊查询 (Ctrl+R 反向搜索 history)

    # 系统 & 资源
    btop            # 比 top 漂亮的 TUI 系统监视器
    dust            # du 的 rust 版，按大小可视化
    duf             # df 的现代版，带分区图
    procs           # ps 的现代版

    # 数据处理
    jq              # JSON 处理
    yq-go           # YAML 处理 (跟 jq 同语法)

    # 网络
    dnsutils        # dig / nslookup
    mtr             # traceroute + ping 二合一

    # 帮助 / 速查
    tealdeer        # tldr 的快速版 —— `tldr tar` 给你常用例子

    # 杂项
    file            # 看文件类型
    tree            # 目录树
  ];
}
