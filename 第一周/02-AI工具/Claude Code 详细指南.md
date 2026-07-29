---
tags:
  - 工具
  - Claude
  - 教程
created: 2026-07-29
type: tool
---

# Claude Code 详细使用指南

> 从安装到精通，手把手带你学会用 Claude Code。

---

## 一、认识 Claude Code

Claude Code 是 Anthropic 推出的**命令行 AI Agent**。它不是普通的聊天工具——它能直接**读你的文件、执行命令、操作 Git、连接外部工具**。

你已经用过的东西，其实就是 Claude Code：

```
你现在看到的每一个操作          背后的机制
─────────────────────────    ─────────────────
读写 Obsidian .md 文件    →   Claude Code 文件工具
执行终端命令               →   Claude Code Shell 工具
修改多个文件               →   Claude Code Edit 工具
Git 操作                   →   Claude Code Git 集成
```

---

## 二、安装

### 方式 1：npm 安装（推荐，最通用）

```bash
# 前提：安装 Node.js (>= 18)
npm install -g @anthropic-ai/claude-code

# 验证安装
claude --version
```

### 方式 2：pip 安装

```bash
pip install claude-code

# 或
pipx install claude-code
```

### 方式 3：免安装运行

```bash
# 直接用 npx 运行，不装全局
npx @anthropic-ai/claude-code
```

---

## 三、第一次使用

### 3.1 获取 API Key

1. 访问 [console.anthropic.com](https://console.anthropic.com)
2. 注册/登录 → API Keys → 创建新 Key
3. 复制 Key（只显示一次！）

### 3.2 设置环境变量

```bash
# Windows PowerShell:
$env:ANTHROPIC_API_KEY = "sk-ant-xxx..."

# Windows CMD:
set ANTHROPIC_API_KEY=sk-ant-xxx...

# 永久设置（推荐）：把上面这行加到系统环境变量
```

### 3.3 启动

```bash
# 在你要工作的项目目录下
cd D:\obsidian1\第一周
claude
```

第一次启动会问你几个问题，按 Y 确认即可。然后你会看到：

```
> 你好，我能帮你做什么？
```

---

## 四、基本对话

Claude Code 的交互方式和普通聊天一样，但有独特的能力：

### 你说什么，它就做什么

```
你：帮我看看这个项目有哪些文件
→ Claude Code 执行 ls，列出文件

你：在 01-AI概念 里把 Token 的页面补充一下
→ Claude Code 读文件、编辑、保存

你：检查所有 Wiki 链接有没有断的
→ Claude Code 遍历所有文件、搜索链接、交叉对比
```

### 关键原则

> **描述你想要的结果，而不是操作的步骤。**

| ❌ 不好的说法 | ✅ 好的说法 |
|-------------|------------|
| "读取 token.md 文件，找到第15行，然后改一下..." | "把 Token 页面里的中英文举例改成表格形式" |
| "执行 grep -r 幻觉 ..." | "检查哪些页面提到了'幻觉'" |

---

## 五、Claude Code 能做什么

### 5.1 文件操作

```
可以                        例如
─────────────────────    ──────────────────────
读取文件                  读完你整个 Obsidian 库
创建新文件                 写一篇新的概念笔记
编辑已有文件               批量补 frontmatter
搜索文件内容               找所有包含 "RAG" 的页面
删除文件                   清理临时文件
```

### 5.2 终端命令

```
可以                        例如
─────────────────────    ──────────────────────
执行任何命令                pip install、git push
安装依赖                    npm install
运行脚本                    python kb_analyzer.py
系统操作                    mkdir、find、curl
```

### 5.3 Git 操作

```
可以                        例如
─────────────────────    ──────────────────────
查看状态                   git status
提交变更                   git commit（自动生成提交信息）
创建分支                   git checkout -b
查看历史                   git log
```

> ⚠️ Claude Code 不会擅自 push，需要你明确说"推送"。

### 5.4 多文件批处理

Claude Code 最大的优势：**一次对话可以同时修改十几个文件**。

```
你：把所有 01-AI概念 里的笔记加上 type: concept 字段
→ 10 个文件，全部自动更新 ✅
```

---

## 六、工作模式

### 6.1 CLAUDE.md —— 项目的"宪法"

在项目根目录放一个 `CLAUDE.md`，Claude Code 每次启动都会先读它。你可以在里面规定：

```markdown
# CLAUDE.md

## 项目规范
- 所有笔记用中文写，术语保留英文
- 每页必须有 YAML frontmatter（tags, created, type）
- Wiki 链接用 [[]] 格式

## 写作风格
- 多用表格和列表
- 每个概念页结尾有"📚 关联"部分
- 不要超过 800 字，太长的拆成子页面
```

有了这个文件，Claude Code 的行为会保持一致，不用每次都重复交代。

### 6.2 三种工作节奏

```
1️⃣ 对话互动
"帮我分析 LLM 和传统 NLP 的区别"
→ Claude 查资料、思考、给出分析

2️⃣ 任务执行
"把这个知识库全部加上 type 字段"
→ Claude 遍历文件、逐个编辑、报告结果

3️⃣ 主动探索
"检查一下我的 Wiki 有没有问题"
→ Claude 读所有文件、查断链、找孤立页面、给出诊断报告
```

---

## 七、实战示例：操作你的 Obsidian 知识库

### 示例 1：创建一篇新笔记

```
你：写一篇 Git 基础笔记，放在 01-AI概念 旁边的新目录 05-开发基础 里，
   覆盖 clone / commit / push / pull / branch / merge，
   每个概念给例子和常见错误

Claude Code 会：
1. 创建 05-开发基础/ 目录
2. 写出完整的 Git 基础笔记
3. 把新页面加入 index.md
```

### 示例 2：批量维护

```
你：检查所有页面，没有 type 字段的补上

Claude Code 会：
1. 遍历所有 .md 文件
2. 识别 frontmatter
3. 按目录规则补充 type
4. 报告：改了 15 个文件，没问题
```

### 示例 3：分析类任务

```
你：我的知识库主要覆盖了哪些话题？画个图给我看

Claude Code 会：
1. 读取所有文件的 tags
2. 统计分类分布
3. 给出建议：AI基础 占 60%，工具对比 偏少
```

---

## 八、实用技巧

### 8.1 控制上下文

| 技巧 | 做法 |
|------|------|
| 长任务分段 | "先做 A，我看到结果后再说 B" |
| 给约束 | "不要超过 500 字"、"用表格呈现" |
| 要求确认 | "修改之前先让我看一下变更清单" |

### 8.2 让 Claude 更懂你

```
你可以在 CLAUDE.md 里写：

## 我的偏好
- 我不是程序员，解释概念时用类比，不要只甩代码
- 我是中文用户，正文用中文
- 我偏好先看结论，再看细节
```

### 8.3 复用好 Prompt

把常用的任务提示存成文件：

```
D:\obsidian1\第一周\.claude\prompts\
├── lint-wiki.txt      # "全面检查知识库健康状况..."
├── new-concept.txt    # "创建一篇新的概念笔记，格式如下..."
└── daily-report.txt   # "根据今天的改动生成日报..."
```

使用时："按照 lint-wiki.txt 的标准，检查一遍知识库"

### 8.4 让 Claude Code 自己读图片

```
你：![[架构图.png]] 按照这张图建目录结构

Claude Code 会：
1. 读取图片
2. 理解图表内容
3. 按图创建文件结构
```

---

## 九、常见问题

### Q：API Key 怎么花钱？

| 模型 | 输入（每百万 Token） | 输出（每百万 Token） |
|------|---------------------|---------------------|
| Haiku | $0.80 | $4.00 |
| Sonnet | $3.00 | $15.00 |
| Opus | $15.00 | $75.00 |

日常对话（Opera）每次几毛到一两块钱。操作文件不额外收费——只按 Token 计。

### Q：它会擅自改我的文件吗？

不会。Claude Code 的每一步文件操作你都看得见。你也可以在对话中说"修改之前先让我确认"。

### Q：它和 ChatGPT / Gemini 的主要区别？

| | Claude Code | ChatGPT | Gemini |
|------|-----------|---------|--------|
| 能操作文件 | ✅ | ❌（网页版） | ❌（网页版） |
| 能执行命令 | ✅ | ❌ | ❌ |
| 上下文 | 200K | 128K | 1M |
| 代码能力 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

### Q：上下文超了怎么办？

Claude Code 会自动压缩历史对话。如果确实需要超长处理，用 RAG 的思路——把信息存成文件，让 Claude 按需读取。

---

## 十、总结

```
Claude Code 的核心心智：

不是"AI 聊天"      而是"AI 同事"
不是"回答问题"      而是"完成任务"
不是"单次对话"      而是"持续协作"
不是"网页工具"      而是"终端里的工程师"
```

你现在的用法（Obsidian + Claude Code）就是最佳实践：**Obsidian 是 IDE，Claude Code 是程序员，知识库是代码库**。你负责方向和审阅，它负责执行和维护。

---

📚 关联：[[Claude使用指南]] | [[Codex使用指南]] | [[Obsidian配置与插件]]
