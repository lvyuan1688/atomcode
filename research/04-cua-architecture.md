# cua (trycua) 架构拆解报告

## 项目概况
- **GitHub**: trycua/cua
- **Stars**: 21,049 (2026-08)
- **License**: MIT
- **语言**: Swift (63%) / Go (14%) / Python (10%) / JS (5%) — 多语言混合
- **定位**: Scale computer-use 2.0 with open-source drivers, cross-OS fleets, and benchmarks

## 核心模块 (4 子包)

### 1. cua-driver (libs/cua-driver)
- **Background computer-use on macOS/Windows/Linux**
- Agent click/type/verify 不抢 cursor 不抢 focus
- 同一 CLI + MCP server 跨三平台
- macOS: Accessibility API (无头)
- Windows: UI Automation API
- Linux: X11 + compositor-specific Wayland routes (raw background input 有显式限制)

### 2. cua-agent (Agent SDK)
- AI agent framework 专为 computer-use 任务
- 见屏幕 → 点按钮 → 自主完成任务
- One API for any VM/container image (cloud or local)

### 3. cua-sandbox (Sandbox SDK)
- Agent-ready sandboxes for any OS
- SDK for creating and controlling sandboxes
- cua-computer-server: driver for UI interactions + code execution in sandboxes

### 4. cua-bench (Benchmarks & RL Environments)
- 评估 computer-use agents on OSWorld / ScreenSpot / Windows Arena / custom tasks
- 导出 trajectories 供训练
- 这是 cua 差异化护城河 — 别的 CUA 框架没有 benchmark suite

### 5. lume (macOS Virtualization)
- macOS/Linux VM management on Apple Silicon
- lumier: Docker-compatible interface for Lume VMs
- 这层是 cua 跑 macOS VM 的底层，跨 OS fleet 依赖这层

## 数据流
```
用户任务 (自然语言: "帮我打开邮件归档所有未读")
  ↓
cua-sandbox 启动 (cloud/local VM, 任 OS)
  ↓
cua-agent 接管 (LLM 看 sandbox 屏幕)
  ↓
Loop:
  1. 截屏 (background, 不抢 cursor)
  2. cua-driver 执行 UI 动作 (click/type/verify)
  3. LLM 评估进展
  ↓
任务完成 → cua-bench 记录 trajectory (可回放/训练)
```

## 可仿制点 (纯架构仿制，不抄代码)

1. **Driver trait + 三 OS 实现**: 这是 cua 最核心架构 — Rust 可仿 `trait ComputerDriver` + macOS/Windows/Linux 三实现，每实现用该 OS 原生 Accessibility API
2. **Background computer-use**: 不抢 cursor 不抢 focus 这点用户感知强 — 仿 background input API 是核心
3. **Sandbox SDK**: create/control sandboxes via one API — 这是 atomcode 目前没有的，可仿 sandbox layer 让 agent 跑在隔离环境
4. **cua-bench trajectories 导出**: agent 每步存 JSONL trajectory，可回放/训模型 — 这是低门槛高粘性 feature
5. **MCP server 暴露 driver**: cua-driver 暴露成 MCP server 让 Claude Code/Cursor 直接用 — atomcode 可仿 MCP server 化

## 仿制策略
- **仓名**: `atomcode-cua` 或独立品牌 `rusty-cua` / `bg-driver`
- **差异化**:
  - Rust 统一实现 (cua 是 Swift+Go+Python 混合，跨语言 debug 痛)
  - 内置 Windows first-class 支持 (cua 文档说支持 Windows 但代码主要 Swift macOS)
  - benchmark suite 简化 (cua-bench 全套太重，仿一个 OSWorld mini)
- **蹭流量**: README 加 "Inspired by trycua/cua" + GitHub topics 加 `cua` `computer-use` `computer-use-agent` `desktop-automation` `background-input`
- **出活速度**: Driver trait + 三 OS 实现 (各 1 天) + MCP server 暴露 (1 天) + trajectory 导出 (0.5 天)，估 5-6 天纯架构重写

## 关键坑预警
1. **Windows UI Automation API 复杂** — Rust 调 Win32 UI Automation 需 `windows-rs` crate，binding 踩坑多
2. **macOS Accessibility 需用户授权** — 仿制品首次跑弹 TCC 授权窗，文档要讲清
3. **Wayland background input 限制多** — cua 文档显式说 compositor-specific，仿制品可先不做 Wayland
4. **跨语言集成 (如果仿 Swift+Rust)** — Swift-Rust FFI 不成熟，不如纯 Rust 简单
