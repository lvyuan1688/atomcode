# OpenClaude 架构拆解报告

## 项目概况
- **GitHub**: Gitlawb/openclaude
- **Stars**: 30,625 (2026-08)
- **License**: Other (需细查，仿制时避开专有部分)
- **语言**: TypeScript (Primary), Astro/CSS/Shell 辅
- **定位**: Open-source coding-agent CLI for cloud and local model providers

## 核心模块

### 1. Provider 统一接口
- OpenAI-compatible APIs / Gemini / GitHub Models / Codex OAuth / Codex / Ollama / Atomic Chat
- `/provider` 引导式配置 + saved profiles
- 一个 CLI 跨云 API 和本地模型后端，无 per-provider 工具

### 2. Tool 系统
- Bash (shell 命令执行)
- File tools (read/write/edit)
- Grep / Glob (搜索)
- Agents (子代理委派)
- Tasks (任务管理)
- MCP (Model Context Protocol 客户端)
- Web tools (URL fetch/search)
- Slash commands (自定义命令)

### 3. 多模态输入
- URL 和 base64 图片输入 (支持 vision provider)
- 流式 token 输出 + tool progress

### 4. gRPC Headless 服务
- `npm run dev:grpc` 启动 gRPC 服务
- bidirectional streaming
- proto 定义在 `src/proto/openclaude.proto`
- 可集成进其他应用 / CI/CD / 自定义 UI

### 5. VS Code 扩展
- bundled VS Code extension
- launch integration + theme support

### 6. 差异化: Pixel-art Hero
- "pixel-art hero companion who fires an arrow every time you press Enter"
- 这种小差异化点用户记忆深，好仿

## 数据流
```
用户输入 (CLI / VS Code 扩展 / gRPC client)
  ↓
Provider 路由 (按 saved profile 选 provider)
  ↓
Tool Loop:
  LLM 调用 (流式) → Tool 执行 → 结果回传 LLM → 迭代
  ↓
Streaming 输出 (token + tool progress 实时)
  ↓
任务完成 / 等待用户输入
```

## 可仿制点 (纯架构仿制，不抄代码)

1. **Provider Profile 持久化**: 用户级 provider profile saved + guided setup — 比 atomcode 现有 config 更友好
2. **Tool 分层**: bash/file/grep/glob/agents/tasks/mcp/web 8 类 tool 清晰切分 — atomcode 可按此分层重构 tool 系统
3. **gRPC Headless**: 把 agent 能力暴露成 gRPC 服务，bidirectional streaming — 这是 atomcode 目前没有的，仿出来可集成进 CI/CD
4. **Slash Commands 自定义**: 用户可定义自己的 slash command — atomcode 已有 slash commands 概念，可强化自定义能力
5. **VS Code 扩展**: bundled extension + theme — atomcode 可仿一个 VS Code 扩展蹭 VS Code 生态流量
6. **Pixel-art Hero**: 这种小差异化点好仿，用户体验提升大

## 仿制策略
- **仓名**: `atomcode-cli` 或独立品牌 `open-agent-cli`
- **差异化**: 比 OpenClaude 更强 gRPC (加 server-streaming + client-streaming 两种) + 更轻 (去掉 VS Code 扩展先做 CLI)
- **蹭流量**: README 加 "Inspired by OpenClaude" + GitHub topics 加 `openclaude` `coding-agent-cli` `mcp`
- **出活速度**: Provider Profile + Tool 8 分层 + gRPC Headless 三模块，估 3-4 天纯架构重写
