---
tags:
  - 工具
  - WorkBuddy
  - Agent
created: 2026-07-29
type: tool
---

# WorkBuddy 搭建 Agent 实操指南

> WorkBuddy 本身就是 Agent 平台，你已经在用了。这篇教你怎么让 Agent 真正"干活"。

---

## 一、WorkBuddy 的 Agent 架构

你电脑上的 `.workbuddy` 目录已经暴露了一切：

```
C:\Users\Zmjjkk\.workbuddy\
├── skills/          ← Agent 的技能库（PDF、Excel、代码…）
├── plugins/         ← 插件扩展
├── connectors/      ← 外部连接器（API、数据库…）
├── connectors-marketplace/  ← 连接器商店
├── plans/           ← AI 自动生成的执行计划
├── memory/          ← Agent 的长期记忆
├── tasks/           ← 任务队列
├── projects/        ← 项目工作区
├── sessions/        ← 对话会话
└── artifact-index/  ← 产物索引
```

> 💡 WorkBuddy 已经是 Agent。你的任务是**告诉它做什么、给它什么工具、让它持续工作**——不是从零搭框架。

---

## 二、实操：从零完成一个 Agent 任务

### 任务：让 WorkBuddy 每天自动抓取 AI 行业新闻，生成中文摘要，存到 Obsidian

这是一个典型的 Agent 用例。分 6 步走。

---

### 第 1 步：创建项目

打开 WorkBuddy → 新建项目 → 命名为 `AI每日摘要Agent`

```
WorkBuddy/ai-daily-agent/
├── DESIGN.md       ← Agent 设计文档
├── pages/          ← 输出页面
└── resources/      ← 原始资料
```

你会得到一个类似 `intern_plan` 的项目结构。

---

### 第 2 步：告诉 Agent 你要什么

在 WorkBuddy 对话中说：

```
我要搭建一个自动化 Agent，功能如下：

1. 每天早上从以下来源抓取 AI 行业新闻：
   - Hacker News 热帖
   - arXiv 最新 AI 论文
   - 机器之心 / 量子位 公众号文章

2. 用 AI 为每篇新闻生成 3 句话中文摘要

3. 将摘要存到 Obsidian 的每日笔记中，格式如下：
   - 文件名：2026-07-29 AI日报.md
   - 包含：标题、来源、摘要、原文链接

4. 处理完发一条通知告诉我完成了
```

---

### 第 3 步：WorkBuddy 会自动出 Plan

WorkBuddy 会把你的需求拆成执行计划，类似：

```
1. [Research] 调研可用的新闻 API / RSS 源
2. [Skill] 创建"AI 新闻抓取"Skill
3. [Skill] 创建"中文摘要生成"Skill
4. [Connector] 配置 Obsidian 连接器
5. [Script] 写自动化脚本串联流程
6. [Publish] 部署为定时任务
```

你审阅一下，觉得合理就确认。

---

### 第 4 步：配置工具链（Connectors + Skills）

WorkBuddy 会自动帮你配置，你只需要确认：

| 配置项 | 做法 |
|--------|------|
| **新闻 RSS / API** | WorkBuddy 会推荐可用的连接器，选一个 |
| **LLM 摘要** | 用内置 AI 或接 Claude API |
| **Obsidian 写入** | 配 Obsidian 本地路径 `D:\obsidian1\第一周\04-每日日报\` |
| **通知** | 微信通知 / 邮件 / 系统通知 |

---

### 第 5 步：测试运行

确认后，WorkBuddy 开始干活。你会在对话中看到：

```
🔍 正在抓取 Hacker News...
✅ 获取 15 篇文章
📝 生成中文摘要中...
✅ 摘要完成
📂 已保存到 D:\obsidian1\第一周\04-每日日报\2026-07-29 AI日报.md
🔔 通知已发送
```

---

### 第 6 步：设为定时任务

让 WorkBuddy 每天早上 8 点自动跑：

```
把这个 Agent 设为每天早上 8:00 自动执行
```

WorkBuddy 会用 Tasks Scheduler 或内置的定时机制安排。

---

## 三、WorkBuddy Agent 的核心模式

你已经在用的 `intern_plan` 项目就是典型用例：

```
你的输入：实习生一个月工作计划
         ↓
WorkBuddy 做的事：
1. 理解需求 → 14 页 PPT 结构
2. 生成 DESIGN.md（视觉规范：颜色、字体、布局）
3. 生成 STORY.md（内容骨架：每页讲什么）
4. 逐页产出 PPT 内容
5. 输出 PDF 最终产物
```

这就是 **Agent 的完整工作流**：需求 → 计划 → 设计规范 → 逐页执行 → 产出。

---

## 四、常见 Agent 场景速查

| 场景 | 你的指令示例 |
|------|-------------|
| 📊 **财报分析** | "分析腾讯 2025 中报，输出：核心指标摘要、收入结构变化、风险提示，保存为 MD 和 PDF" |
| 📈 **数据看板** | "从这 3 个月的 CSV 数据生成一个交互式 HTML 看板" |
| 📝 **文档生成** | "根据 DESIG.md 和 STORY.md 的规范，生成 14 页 PPT" |
| 🔍 **竞品分析** | "对比 Claude Code 和 Codex 的差异，输出对比表格和雷达图" |
| 📰 **RSS 摘要** | "订阅这个 RSS 源，每天生成中文简报" |
| 💻 **代码开发** | "用 Python 写一个 Obsidian 笔记分析器，支持 JSON 输出" |

---

## 五、WorkBuddy vs Claude Code 的分工

| 场景 | 用什么 | 原因 |
|------|--------|------|
| 改 Obsidian 笔记 | **Claude Code** | 直接操作本地文件 |
| 生成完整 PPT/PDF | **WorkBuddy** | 有 PPT 引擎和模板 |
| 数据分析 + 图表 | **WorkBuddy** | 有数据连接器和可视化 |
| 写代码脚本 | 两者都行 | Claude Code 更灵活 |
| 定时自动化任务 | **WorkBuddy** | 有任务调度 |
| 网页抓取 + 处理 | **WorkBuddy** | 有内置浏览器和 API 连接器 |

> 💡 最佳实践：WorkBuddy 做"重活儿"（PPT、数据、定时任务），Claude Code 做"细活儿"（文件编辑、Git、终端操作）。

---

## 六、打开 WorkBuddy 立刻试试

1. 双击桌面 `WorkBuddy` 或 `CC Switch` 启动
2. 新建项目
3. 粘贴这段：

```
帮我搭一个 Agent：每天监控我 Obsidian 知识库中的 04-每日日报 目录，
如果当天没有日报，自动提醒我写；
如果有新笔记加入 01-AI概念，自动更新 index.md 的索引条目。
```

4. 看 WorkBuddy 怎么拆解、执行

---

📚 关联：[[WorkBuddy功能脑图]] | [[Claude使用指南]] | [[Claude vs Codex 实战对比]]
