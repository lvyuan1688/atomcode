# Browser Use 架构拆解报告

## 项目概况
- **GitHub**: browser-use/browser-use (原 pip 包 browser-use)
- **Stars**: 86,000+ (2026-08)
- **License**: MIT
- **语言**: Python (Primary)
- **定位**: Give any LLM the ability to control a web browser — AI agents navigate, click, fill, extract data

## 核心模块

### 1. Browser 后端抽象
- **Playwright** (默认后端，最稳)
- **Selenium** (兼容老浏览器)
- **Cdp** (Chrome DevTools Protocol 直连，绕过 Playwright overhead)
- 统一 `Browser` 接口，后端可切

### 2. Agent Loop
- LLM 看 DOM 截图 → 决定动作 → 执行 → 截新图 → 迭代
- 动作类型: click / type / scroll / navigate / extract / done
- 每步存 trajectory (截图 + 动作 + 结果) 供回放/调试

### 3. DOM 提取与压缩
- 完整 DOM 太大塞不进 LLM context
- 提取交互元素 (button/input/a) + 可见性过滤 + 坐标标注
- 压缩成 LLM 可读的 "element list with index"

### 4. Vision 模式
- 不读 DOM，直接看截图 (用 vision LLM 如 GPT-4V/Claude Vision)
- 适合 Canvas/Flash 等无 DOM 场景
- 成本高但成功率高

### 5. 多 Tab 管理
- Agent 可开新 tab / 切 tab / 关 tab
- 每个 tab 独立 context

### 6. 持久化 Cookie/Session
- 跨 run 复用登录态
- `browser_profile` 目录存 cookie/localStorage

## 数据流
```
用户任务 (自然语言)
  ↓
Agent 初始化 (选 LLM + 选 browser 后端)
  ↓
Loop:
  1. 提取当前页 DOM → 压缩成 element list
  2. 截图 (可选 vision 模式)
  3. LLM 决策: "click element 5" / "type 'hello' into element 3"
  4. 执行动作 (Playwright/Selenium/Cdp)
  5. 等待页面稳定 → 截新图
  6. 判断任务是否完成
  ↓
任务完成 → 返回提取的数据 / 操作结果
```

## 可仿制点 (纯架构仿制，不抄代码)

1. **Browser 后端 trait**: Python 抽象基类 `Browser` + Playwright/Selenium/Cdp 三实现 — Rust 可仿 `trait Browser` + 三实现
2. **DOM 压缩算法**: 提取交互元素 + 坐标标注 + 可见性过滤 — 这算法可纯架构重写，是核心差异化
3. **Vision + DOM 双模式**: 大部分仿制品只做 DOM 模式，加 vision 双模式是差异化
4. **Trajectory 持久化**: 每步截图+动作存 JSONL，可回放/调试 — atomcode 可加 trajectory 记录
5. **多 Tab Context**: 每个 tab 独立 context 管理复杂任务 — atomcode 浏览器控制可加多 tab
6. **Cookie 持久化目录**: `browser_profile/` 跨 run 复用登录态 — 这是用户痛点，仿出来粘性高

## 仿制策略
- **仓名**: `atomcode-browser` 或独立品牌 `rusty-browser-agent`
- **差异化**: 
  - Rust 实现 (Browser Use 是 Python，Rust 版性能好蹭 Rust 生态流量)
  - 双模式 (DOM + Vision) 比 Browser Use 单 DOM 模式更强
  - 内置 trajectory 回放 UI (Browser Use 需要额外工具)
- **蹭流量**: README 加 "Inspired by Browser Use" + GitHub topics 加 `browser-use` `browser-automation` `playwright` `ai-agent`
- **出活速度**: Browser trait + DOM 压缩 + Agent Loop 三模块，估 3-4 天纯架构重写 (Rust 比 Python 慢但性能好)
- **蹭 86k 星的流量**: Browser Use 是这个赛道绝对王者，任何仿制品都会被搜到，README/Topics/Demo 三处蹭足

## 关键坑预警
1. **Playwright Rust binding 不成熟** — 可能需 FFI 调 Python Playwright，或用 `chromiumoxide` crate
2. **DOM 压缩算法是核心机密** — Browser Use 源码里这函数实现细节需精读，纯架构重写要理解算法不抄代码
3. **Vision 模式成本高** — 仿制品可默认 DOM 模式，vision 做可选增强
