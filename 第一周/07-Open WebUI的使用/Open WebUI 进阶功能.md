---
tags:
  - AI
  - Open WebUI
  - 工具
  - 进阶
created: 2026-07-31
type: concept
---

# Open WebUI 进阶功能深度研究

> Open WebUI 不只是 ChatGPT 的本地替代品——它是一个完整的 **LLM 操作系统中枢**。

---

## 一、架构总览

```
┌─────────────────────────────────────────────────────────┐
│                    Open WebUI                            │
│                                                         │
│  ┌─────────┐  ┌─────────┐  ┌──────────┐  ┌──────────┐  │
│  │ 多用户   │  │  API    │  │  Tools   │  │ Pipeline  │  │
│  │ 管理    │  │  接口   │  │  Functions│  │  管道     │  │
│  └─────────┘  └─────────┘  └──────────┘  └──────────┘  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │              模型 API 对接层                      │   │
│  │   Ollama  │  OpenAI  │  Anthropic  │  自定义     │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 二、API 接口

### 2.1 兼容 OpenAI API

Open WebUI 对外暴露 **完全兼容 OpenAI API 格式** 的接口，任何支持 OpenAI 的客户端都能直接切换过来：

```bash
# 只需改 base_url 和 api_key
curl http://localhost:3000/api/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3",
    "messages": [{"role": "user", "content": "你好"}]
  }'
```

### 2.2 关键端点

| 端点 | 功能 |
|------|------|
| `/api/v1/chat/completions` | 对话补全（兼容 OpenAI） |
| `/api/v1/models` | 列出可用模型 |
| `/api/v1/embeddings` | 文本嵌入 |
| `/api/chat/completions` | 原生对话接口（含 RAG） |
| `/api/retrieval` | 文档检索 |
| `/api/tools` | 工具管理 |
| `/api/functions` | 函数管理 |

### 2.3 API Key 管理

```
管理员面板 → 设置 → API Keys
  → 生成 Key（可设权限范围）
  → 控制：哪些模型可用、速率限制、过期时间
```

> 💡 在企业场景中：每个部门一个 Key，A 部门只能用内部模型，B 部门可调云端 API。

---

## 三、Tools 工具调用

### 3.1 什么是 Tools

Tools 是 Open WebUI 版的 **Function Calling**——让 LLM 在对话中自主调用外部工具。

```
用户: "帮我查一下今天北京天气，然后发邮件给老板请假"

LLM 思考 → 需要两个工具
  ├── Tool 1: get_weather(city="北京")  → 调用天气 API
  ├── Tool 2: send_email(to="老板", body="请假...") → 发邮件
  └── 综合结果 → 输出回复
```

### 3.2 内置 Tools

| 工具 | 功能 |
|------|------|
| **Web Search** | 联网搜索（支持 Google/Bing/SearXNG） |
| **Calculator** | 数学计算 |
| **Code Interpreter** | Python 代码执行 |
| **Image Generation** | 调用 DALL-E / Stable Diffusion |
| **RAG** | 文档检索增强生成 |

### 3.3 自建 Tool（JSON 定义）

```json
{
  "name": "get_stock_price",
  "description": "获取指定股票的实时价格",
  "parameters": {
    "type": "object",
    "properties": {
      "symbol": {
        "type": "string",
        "description": "股票代码，如 AAPL、600519"
      }
    },
    "required": ["symbol"]
  },
  "endpoint": "https://your-api.com/stock",
  "method": "GET",
  "headers": {
    "Authorization": "Bearer xxx"
  }
}
```

**三种实现方式**：

| 方式 | 适用场景 |
|------|---------|
| **HTTP Endpoint** | 调用外部 API（天气、股票、数据库） |
| **Python Script** | 复杂逻辑、本地计算 |
| **LangChain Tool** | 已有 LangChain 生态的工具直接导入 |

---

## 四、Functions 函数

### 4.1 Tools vs Functions 的区别

| | Tools | Functions |
|------|-------|-----------|
| **触发方式** | LLM 自主决定何时调用 | 用户手动触发或管道自动触发 |
| **用途** | 对话中动态解决问题 | 预处理 / 后处理 / 过滤器 |
| **运行时机** | 对话进行中 | 消息发送前、接收后 |
| **典型场景** | 查天气、搜网页 | 内容过滤、格式转换、敏感词检测 |

### 4.2 Function 类型

#### 入口函数（Inlet Functions）

在**用户消息发给 LLM 之前**执行：

```python
# 自动添加系统提示词
def add_system_prompt(user_message, metadata):
    return f"[当前时间: {datetime.now()}]\n\n{user_message}"
```

#### 出口函数（Outlet Functions）

在 **LLM 回复返回给用户之前**执行：

```python
# 敏感信息过滤
def filter_sensitive(llm_response, metadata):
    keywords = ["密码", "SSN", "身份证"]
    for kw in keywords:
        llm_response = llm_response.replace(kw, "[已隐藏]")
    return llm_response
```

#### 过滤器函数（Filter Functions）

按 **权限级别** 控制访问：

```python
# 限制某些用户只能调用特定模型
def model_filter(user, request):
    if user.role == "basic":
        request.model = "llama3:8b"  # 强制用轻量模型
    return request
```

### 4.3 实际应用

| 场景 | 函数类型 | 做什么 |
|------|---------|--------|
| 企业合规 | 出口 | 拦截涉密词汇 |
| 成本控制 | 过滤器 | 限制免费用户用便宜模型 |
| 多语言 | 入口 | 自动检测语言 + 翻译 |
| 日志审计 | 出口 | 记录所有对话到数据库 |
| Prompt 增强 | 入口 | 自动注入用户角色/权限/上下文 |

---

## 五、Pipeline 管道

### 5.1 什么是 Pipeline

Pipeline 是 Open WebUI 最强大的功能——把多个处理步骤**串联成自动化流水线**。

```
输入消息
  │
  ├── [Inlet Filter]  敏感词检测
  ├── [Inlet Function] 添加系统上下文
  │
  ▼
  LLM 推理
  │
  ├── [Outlet Function] 结果格式化
  ├── [Outlet Filter]  合规检查
  │
  ▼
输出回复
```

### 5.2 Pipeline 配置示例

```yaml
# pipelines/customer_service.yaml
name: "客服管道"
steps:
  - type: inlet_filter
    name: "敏感词过滤"
    function: filter_sensitive_words
    
  - type: inlet_function
    name: "注入知识库"
    function: inject_knowledge_base
    config:
      kb_path: "/data/kb/customer_service"
      
  - type: model
    name: "主推理"
    model: "qwen2.5:14b"
    
  - type: outlet_function
    name: "自动翻译"
    function: translate_if_needed
    
  - type: outlet_filter
    name: "合规检查"
    function: compliance_check
```

### 5.3 Pipeline 实战场景

| 场景 | 管道结构 |
|------|---------|
| **客服机器人** | 敏感词过滤 → 注入FAQ知识库 → LLM → 满意度评分 |
| **代码审查** | 语法检查 → 注入项目规范 → LLM → 格式化输出 |
| **文档翻译** | 语种检测 → LLM 翻译 → 术语一致性校验 → 格式还原 |
| **多模型仲裁** | 同时发 3 个模型 → 投票/择优 → 返回最佳答案 |
| **RAG 增强** | 查询改写 → 向量检索 → 上下文拼接 → LLM → 引用标注 |

---

## 六、多用户管理

### 6.1 角色体系

```
┌──────────┐
│  Admin   │  全部权限：用户管理、模型管理、系统配置
├──────────┤
│ Manager  │  管理指定组的用户和权限
├──────────┤
│  User    │  使用模型、创建对话、上传文档
├──────────┤
│ Pending  │  注册后等待审批
└──────────┘
```

### 6.2 权限粒度

| 控制维度 | 说明 |
|----------|------|
| **模型权限** | 用户 A 可用 GPT-4，用户 B 只能用 Llama |
| **速率限制** | 每人每小时最多 100 次调用 |
| **Token 配额** | 每月 Token 用量上限 |
| **功能开关** | 是否允许联网搜索、文件上传、代码执行 |
| **知识库访问** | 哪些用户可以检索哪些文档库 |

### 6.3 LDAP / OAuth 集成

```bash
# 环境变量配置
OAUTH_CLIENT_ID=xxx
OAUTH_CLIENT_SECRET=xxx
OAUTH_PROVIDER=google  # 或 github / microsoft / custom
```

支持对接企业已有的账号体系，无需重新注册。

---

## 七、模型 API 对接

### 7.1 对接架构

```
Open WebUI
    │
    ├── Ollama（本地）
    │     └── llama3, qwen2.5, mistral...
    │
    ├── OpenAI 兼容（云端/自建）
    │     ├── OpenAI GPT-4o
    │     ├── Anthropic Claude（via 兼容代理）
    │     ├── 通义千问 / DeepSeek / 智谱
    │     └── vLLM / TGI 自部署
    │
    └── 自定义 API
          └── 任何实现 /chat/completions 的服务
```

### 7.2 对接 OpenAI 兼容模型

管理员面板 → 设置 → 模型 → 添加：

```yaml
# 对接 DeepSeek
URL: https://api.deepseek.com/v1
API Key: sk-xxx
Prefix: deepseek-  # 模型名前缀，用于区分来源
```

```yaml
# 对接 Claude（via Anthropic-compatible proxy）
URL: http://localhost:8080/v1
API Key: sk-ant-xxx
Prefix: claude-
```

### 7.3 对接本地 Ollama

```bash
# 1. 确保 Ollama 在运行
ollama serve

# 2. Open WebUI 自动检测
# 设置 → 模型 → 自动发现 → 所有 Ollama 模型自动出现

# 3. 或者手动指定
OLLAMA_BASE_URL=http://host.docker.internal:11434
```

### 7.4 多模型同时在线

Open WebUI 的核心优势：**一个界面，同时挂载多个后端**。

```
对话界面下拉框：
  ├── 🏠 llama3:8b          (本地，免费，快)
  ├── 🏠 qwen2.5:14b        (本地，中文好)
  ├── ☁️ GPT-4o             (云端，最强)
  ├── ☁️ claude-3.5-sonnet  (云端，长文本)
  └── ☁️ deepseek-chat      (云端，便宜)
```

用户每一次对话都可以切换模型，不同任务用不同模型。

### 7.5 模型别名与路由

```yaml
# 自动路由：闲聊走便宜模型，复杂任务走强模型
routing:
  - pattern: "翻译|总结|闲聊"
    model: "llama3:8b"
  - pattern: "代码|分析|推理"
    model: "claude-3.5-sonnet"
  - default: "qwen2.5:14b"
```

> 💡 Open WebUI 的最大优势：开源、可私有化部署、一个界面管理所有模型、Pipeline 编排能力强。

---

📚 关联：[[LLM大语言模型]] | [[Agent智能体]] | [[MCP协议]] | [[RAG检索增强生成]]
