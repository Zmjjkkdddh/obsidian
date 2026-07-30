---
marp: true
theme: uncover
class:
  - lead
paginate: true
backgroundImage: none
style: |-
  :root {
    --color-background: #f8f9fa;
    --color-foreground: #1a1a2e;
    --color-accent: #3B82F6;
    --color-highlight: #F59E0B;
  }
  section.lead {
    background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 60%, #0EA5E9 100%);
    color: white;
  }
  section.lead h1 { font-size: 2.5em; }
  section.lead p { color: rgba(255,255,255,0.85); }
  h2 { color: #1E3A8A; border-bottom: 3px solid #3B82F6; padding-bottom: 8px; }
  table { font-size: 0.8em; }
  strong { color: #3B82F6; }
  code { background: #e8f0fe; color: #1E3A8A; padding: 2px 6px; border-radius: 4px; }
---

# 🧠 AI 知识库

## 从零到结构的 LLM 学习之旅

<p style="margin-top:40px;opacity:0.8;">2026-07-30  |  25 页笔记  |  7 个章节</p>

---

## 📊 知识库概览

| 指标 | 数值 |
|------|------|
| **总页面数** | 25 篇 |
| **总字数** | ~15,000 字 |
| **Wiki 链接** | 50+ 条 |
| **目录数** | 7 个章节 |
| **核心枢纽** | RAG检索增强生成（6 入链） |

```
AI概念 10篇 ████████████████████ 40%
AI工具  5篇 ██████████ 20%
日报    5篇 ██████████ 20%
实践    2篇 ████ 8%
对比    1篇 ██ 4%
资料    1篇 ██ 4%
索引    1篇 ██ 4%
```

---

## 🗂️ 目录结构

```
AI知识库/
├── 01-AI概念/     ← 10 篇核心概念
├── 02-AI工具/     ← 5 篇工具指南
├── 03-工具对比/    ← 横向对比分析
├── 04-每日日报/    ← 学习日报 + 实践
├── 05-WorkBuddy/  ← WorkBuddy 实战
├── 06-资料/       ← 方法论参考
└── index.md       ← 全库导航索引
```

每篇笔记都配有 **YAML 元数据**（tags / created / type），支持 **Dataview** 查询。

---

## 📚 01 — AI 核心概念（10 篇）

<div style="columns:2;font-size:0.8em;">

- **LLM 大语言模型** — 总览入口
- **Token 是什么** — 最小单位
- **上下文窗口** — 记忆容量
- **幻觉问题** — 为什么"编造"
- **Agent 智能体** — 自主行动框架
- **RAG 检索增强生成** — 证据驱动
- **向量数据库 & Embedding** — 语义搜索
- **MCP 协议** — 工具通信标准
- **Prompt Engineering** — 提示词技巧
- **Fine-tuning 微调** — 模型定制

</div>

> 核心设计：每篇独立可读，通过 Wiki 链接互联

---

## 🔧 02 — AI 工具指南（5 篇）

| 工具 | 内容 |
|------|------|
| **Claude 使用指南** | Claude vs Claude Code 区别、模型对比 |
| **Claude Code 详细指南** | 安装 → 精通，手把手教程 |
| **Codex 使用指南** | OpenAI CLI Agent 概述 |
| **WorkBuddy Agent 指南** | 从零搭建 Agent 六步法 |
| **Obsidian 配置** | 插件推荐 + AI 协作方案 |

```
Claude Code = Claude 模型 + 文件系统 + 终端 + Git + MCP
WorkBuddy  = 内置 Skills + Connectors + Plans + Memory
```

---

## ⚖️ 03 — 工具横向对比

| 维度 | Claude | ChatGPT | Gemini | DeepSeek |
|------|--------|---------|--------|----------|
| 厂商 | Anthropic | OpenAI | Google | DeepSeek |
| 上下文 | **200K** | 128K | 1M~2M | 128K |
| 代码 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 中文 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 价格 | 中 | 中 | 低 | 极低 |
| 开源 | ❌ | ❌ | ❌ | ✅ |

### Agent 工具

| | Claude Code | Codex | Cursor |
|------|-------------|-------|--------|
| MCP | ✅ 原生 | ✅ | ✅ |
| 文件操作 | ✅ | ✅ | ✅ |

---

## 📝 04 — 每日学习记录（5 篇）

| 日期 | 主题 |
|------|------|
| **7/28** | AI 基础概念 + Git 搭建 |
| **7/29** | WorkBuddy 入门与结构研究 |
| **7/30** | WorkBuddy 工作流自动化 |

### 实践项目

- **Jerry Runner** 🐭 — Canvas 游戏开发（三挡速度调节）
- **kb_analyzer.py** — Python 知识库分析脚本
- **WorkBuddy 自动化报告** — HTML 可视化报告

> 每天一篇日报，模板统一，元数据完整

---

## 🤖 05 — WorkBuddy 实战

### 功能脑图
```
WorkBuddy
├── 文档处理（PDF/Word/Excel/PPT）
├── 数据分析（A股/港股/美股/图表）
├── 编程开发（全栈/脚本/代码审查）
├── Agent 构建（Skills + Connectors + Plans）
└── 自动化（定时任务 + 工作流）
```

### 已完成项目

| 项目 | 产出 |
|------|------|
| 腾讯财报分析 | PDF → 摘要 + Excel + Word 报告 |
| 实习计划 PPT | 14 页商务现代风格 |
| Obsidian 分析 | 自动生成 HTML 可视化报告 |

---

## 🏗️ 知识库设计原则

<div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;text-align:left;font-size:0.85em;">

**结构化**
- YAML frontmatter 统一管理
- 目录按主题分类
- type 字段标识页面类型

**互联互通**
- Wiki 链接贯穿全局
- 零断链保证
- 核心枢纽页面自然形成

**可维护**
- index.md 全库导航
- 每日日报追踪进度
- Lint 定期健康检查

**AI 协作**
- Claude Code 直接读写
- WorkBuddy 自动化处理
- Obsidian 图视图可视化

</div>

---

## 📈 成长轨迹

```
7/28  ██ 10篇概念页建立，知识框架成型
7/29  ███ 工具指南 + 对比分析，WorkBuddy 入门
7/30  ████ 实战项目：游戏开发 + 自动化报告
      ─────────────────────────────────────→
      从知识消费 → 工具使用 → 项目实践
```

- **概念层**：LLM / Agent / RAG / MCP 全覆盖
- **工具层**：Claude Code / Codex / WorkBuddy 熟练使用
- **实践层**：代码开发 / 自动化工作流 / 游戏制作

---

## 🎯 下一步

| 方向 | 计划 |
|------|------|
| 📖 **深挖概念** | Agent 架构、RAG 技术栈独立展开 |
| 🛠️ **工具对比** | Claude Code vs Codex 同任务实战 |
| 🚀 **更多实践** | WorkBuddy 每日自动化 + Git 备份 |
| 📊 **可视化** | Dataview 动态仪表盘 |

---

# 🙏 谢谢

<p style="font-size:1.2em;opacity:0.8;">知识库 = Obsidian + Claude Code + WorkBuddy</p>

<p style="margin-top:30px;opacity:0.6;">25 页笔记 · 50+ 链接 · 零断链 · 持续增长</p>
