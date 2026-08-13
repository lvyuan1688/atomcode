# CodeWhale 架构拆解报告

## 项目概况
- **GitHub**: Hmbown/CodeWhale
- **Stars**: 40,675 (2026-08)
- **License**: MIT
- **语言**: Rust (Primary)
- **定位**: Open-source, community-driven agent harness — bring your own model

## 核心模块

### 1. Provider 抽象层
- 30+ provider 统一接口 (DeepSeek, Claude, GPT, Kimi, GLM, vLLM, SGLang, Ollama)
- 角色系统: 每个角色显式记录 `provider` + `model` + reasoning tier
- 价格/上下文限制来自真实路由，未知价格显示 unknown 而非 $0

### 2. Agent Loop
- 读代码 → 编辑文件 → 运行命令 → 自检 → 停止
- 交互模式 (TUI) + 脚本模式 (`codewhale exec`)
- 任务中途 `/model` 切换模型

### 3. TUI (Terminal UI)
- Rust 实现，differential rendering
- 多语言 i18n 支持

## 数据流
```
用户输入 (TUI/CLI)
  ↓
Provider 路由 (按角色选 provider+model)
  ↓
LLM 调用 (流式 token)
  ↓
Tool Dispatch (file edit / bash / search)
  ↓
Verify (cargo build/test 自检)
  ↓
迭代直到任务完成或需要用户输入
```

## 可仿制点 (纯架构仿制，不抄代码)

1. **Provider 抽象**: Rust trait `LlmProvider` + 30+ 实现 — 这层最好仿，定义统一 trait 各 provider 实现
2. **角色持久化**: 角色配置存 TOML/JSON，显式记录 provider/model/tier — 比 atomcode 现有 config 更精细
3. **Verify 闭环**: tool 执行后自动跑 `cargo build` 自检 — atomcode 已有类似 verify 概念，可强化
4. **exec 模式**: `codewhale exec "task"` 非交互脚本模式 — atomcode 可加 `atomcode exec` 子命令
5. **i18n**: 多语言 TUI — atomcode 当前英文 only，加 i18n 是低门槛差异化

## 仿制策略
- **仓名**: `atomcode-whale` 或独立品牌 `rusty-agent`
- **差异化**: 比 CodeWhale 更轻 (去掉 30+ provider, 专注 top 5) + 更强 verify (支持多语言 verify 不只 cargo)
- **蹭流量**: README 加 "Inspired by CodeWhale" + GitHub topics 加 `codewhale` `agent-harness`
- **出活速度**: Provider 抽象 + Agent Loop + TUI 三模块，估 2-3 天纯架构重写
