---
tags:
  - 教程
  - Claude
  - Mac
created: 2026-07-31
type: tool
---

# Mac 安装 Claude Code 详细步骤

> 不是 Claude 桌面应用（那个要登录、国内用不了）。
> 是 Claude Code——终端里跑的，API Key 即开即用，Windows 上你已经在用的同一个东西。

---

## 第 1 步：确保 Mac 能上外网

Claude Code 走 API，请求要发到 `api.anthropic.com`，所以 Mac 必须先能访问外网。

**如果你的 Mac 还没通外网**：用 Windows 共享代理临时过渡：

```
Mac 系统设置 → 网络 → Wi-Fi → 详细信息 → 代理 → SOCKS 代理
服务器: 192.168.31.29
端口: 1081
```

设完后 Safari 打开 `google.com` 试一下，能打开就行。

---

## 第 2 步：安装 Node.js（Claude Code 的依赖）

打开终端（`Cmd+空格` → 输入 `Terminal`），粘贴：

```bash
# 安装 Homebrew（如果没有的话，只需一次）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 用 Homebrew 装 Node.js
brew install node

# 验证
node --version    # 应该输出 v22.x.x 或 v24.x.x
npm --version     # 应该输出 10.x.x
```

> Homebrew 安装时如果弹出密码框——正常，输 Mac 登录密码就行。

---

## 第 3 步：配置 npm 走代理（关键！）

npm 默认从 `registry.npmjs.org` 下载，在国内可能被墙。设代理让它走你 Mac 已有的 SOCKS 通道：

```bash
# 临时设（当前终端窗口有效）
export HTTP_PROXY=socks5://127.0.0.1:1081
export HTTPS_PROXY=socks5://127.0.0.1:1081
```

> 如果你没开 Mac 本地代理（还在用 Windows 共享），把 `127.0.0.1` 换成 `192.168.31.29`。

---

## 第 4 步：安装 Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

下载大概一分钟。装完后验证：

```bash
claude --version
# 应该输出版本号，类似 2.1.220
```

---

## 第 5 步：配置 API Key

API Key 和 Windows 上用的是同一个。在 Windows 终端跑这个获取：

```powershell
echo %ANTHROPIC_API_KEY%
# 或者在 Claude Code 工作目录下找 .env 文件
```

拿到 Key 后，Mac 上设：

```bash
# 临时设（当前终端有效）
export ANTHROPIC_API_KEY="sk-ant-api03-你的key..."

# 永久设（写入配置文件，以后每次打开终端自动生效）
echo 'export ANTHROPIC_API_KEY="sk-ant-api03-你的key..."' >> ~/.zshrc
source ~/.zshrc
```

验证是否设成功：

```bash
echo $ANTHROPIC_API_KEY
# 应该输出你的 Key
```

> ⚠️ **API Key 是付费的**，按使用量扣费。用 Haiku 模型（最便宜）的话，日常对话一次几毛钱。你 Windows 上已经在用了，Mac 上共用同一个 Key，账单合并。

---

## 第 6 步：启动 Claude Code

```bash
# 进入你的项目目录（比如你要操作的 Obsidian 库）
cd ~/你的文件夹

# 启动
claude
```

第一次启动可能会问你几个确认问题，一律 Y。然后就是熟悉的界面：

```
> 你好，我能帮你做什么？
```

---

## 第 7 步（可选）：让 Mac 也用同一个 Obsidian 库

如果你想把 Obsidian 库同步到 Mac 上，用 iCloud 或 Git：

### 方式 A：iCloud 同步（最简单）

Windows 上把 Obsidian 库移到 iCloud 目录 → Mac 上自动同步到 `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/`

### 方式 B：Git 同步

```bash
# Mac 上
cd ~
git clone 你的GitHub仓库地址
cd 第一周
claude
```

启动后 Claude Code 就能读你的所有笔记了。

---

## 完整流程总结

```bash
# 依次粘贴到 Mac 终端，每步等完成后看输出确认成功：
brew install node                          # 第 2 步
export HTTPS_PROXY=socks5://127.0.0.1:1081 # 第 3 步
npm install -g @anthropic-ai/claude-code    # 第 4 步
export ANTHROPIC_API_KEY="sk-ant-..."      # 第 5 步
claude                                      # 第 6 步
```

---

## 常用命令

| 命令 | 作用 |
|------|------|
| `claude` | 在当前目录启动 |
| `claude --model haiku` | 用便宜模型（省钱） |
| `claude --model sonnet` | 用主力模型（默认） |
| `echo $ANTHROPIC_API_KEY` | 检查 Key 是否设好 |
| `npm update -g @anthropic-ai/claude-code` | 升级版本 |

---

## 和 Windows 版的区别

| | Windows | Mac |
|------|---------|-----|
| 安装 | `irm ... \| iex` | `npm install -g @anthropic-ai/claude-code` |
| 设 Key | `set ANTHROPIC_API_KEY=...` | `export ANTHROPIC_API_KEY="..."` |
| 启动命令 | `claude` | `claude` |
| 交互体验 | 完全一样 | 完全一样 |
| 快捷键 | 相同 | 相同 |

**两条命令本质是同一个东西**——只是安装方式不同，启动后看到的、用到的、能做的一模一样。
