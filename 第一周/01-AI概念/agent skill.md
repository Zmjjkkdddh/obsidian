---
tags:
  - AI
  - Agent
  - Skill
created: 2026-07-31
type: concept
---

# Agent Skill 简要解析

### 1. 核心原理

[](https://github.com/XWS-prog/GIT/blob/main/%E6%88%91%E7%9A%84ai%E8%AE%A4%E8%AF%86/ai%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5/Agent%20Skill%E7%AE%80%E8%A6%81%E8%A7%A3%E6%9E%90.md#1-%E6%A0%B8%E5%BF%83%E5%8E%9F%E7%90%86)

**Agent Skill** 的本质是**将大语言模型（LLM）的“思考能力”与外部“执行能力”进行解耦和模块化封装**。从元信息层进行思考后再调用指令层的各种指令，比单纯的Prompt输入更具有**准确性**，排除了其他Skill的干扰

- **思考层（LLM）**：负责理解用户意图、决定调用哪个技能、并解析技能返回的结果。
    
- **执行层（Skill）**：是一段可执行的代码（函数/API），负责完成具体的操作（如查天气、发邮件、算数学）。
    
- **关键机制**：LLM 并不亲自去执行操作，而是通过 **函数调用（Function Calling）** 或 **提示词指令（Prompting）** 来“选择”并“触发”一个 Skill，Skill 执行完后将结果返回给 LLM，由 LLM 组织成自然语言回复用户。
    

---

### 2. 运行模式（三步循环）

[](https://github.com/XWS-prog/GIT/blob/main/%E6%88%91%E7%9A%84ai%E8%AE%A4%E8%AF%86/ai%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5/Agent%20Skill%E7%AE%80%E8%A6%81%E8%A7%A3%E6%9E%90.md#2-%E8%BF%90%E8%A1%8C%E6%A8%A1%E5%BC%8F%E4%B8%89%E6%AD%A5%E5%BE%AA%E7%8E%AF)

|阶段|谁在做事|做什么|
|---|---|---|
|**① 意图识别与路由**|LLM|分析用户输入，匹配最合适的 Skill（比如用户问“几点了”，就匹配 `get_current_time` 技能）。|
|**② 执行与反馈**|Skill（代码）|运行对应的函数（可能调用外部API、查数据库或计算），得到结构化数据（如 `{"time": "14:30"}`）。|
|**③ 结果生成**|LLM|接收技能返回的数据，将其转化为友好、自然的语言回复用户（如“现在是下午2点30分”）。|

> **注意**：整个过程中，LLM 只负责“脑力劳动”，Skill 负责“体力劳动”。

---

### 3. 小例子：天气查询 Agent

[](https://github.com/XWS-prog/GIT/blob/main/%E6%88%91%E7%9A%84ai%E8%AE%A4%E8%AF%86/ai%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5/Agent%20Skill%E7%AE%80%E8%A6%81%E8%A7%A3%E6%9E%90.md#3-%E5%B0%8F%E4%BE%8B%E5%AD%90%E5%A4%A9%E6%B0%94%E6%9F%A5%E8%AF%A2-agent)

**场景**：用户说 _“北京今天天气怎么样？”_

#### 步骤 1：路由

[](https://github.com/XWS-prog/GIT/blob/main/%E6%88%91%E7%9A%84ai%E8%AE%A4%E8%AF%86/ai%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5/Agent%20Skill%E7%AE%80%E8%A6%81%E8%A7%A3%E6%9E%90.md#%E6%AD%A5%E9%AA%A4-1%E8%B7%AF%E7%94%B1)

Agent 内置了两个 Skill：

- `get_weather(city)` → 调用天气 API
    
- `send_email(content)` → 发送邮件
    

LLM 分析用户输入，发现关键词“天气”，于是决定调用 `get_weather`，并提取参数 `city = "北京"`。

#### 步骤 2：执行

[](https://github.com/XWS-prog/GIT/blob/main/%E6%88%91%E7%9A%84ai%E8%AE%A4%E8%AF%86/ai%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5/Agent%20Skill%E7%AE%80%E8%A6%81%E8%A7%A3%E6%9E%90.md#%E6%AD%A5%E9%AA%A4-2%E6%89%A7%E8%A1%8C)

Agent 运行 `get_weather("北京")` 这个函数，它向天气 API 发起请求，得到原始返回：

json

{ "temp": 28, "condition": "晴", "humidity": "45%" }

#### 步骤 3：生成回复

[](https://github.com/XWS-prog/GIT/blob/main/%E6%88%91%E7%9A%84ai%E8%AE%A4%E8%AF%86/ai%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5/Agent%20Skill%E7%AE%80%E8%A6%81%E8%A7%A3%E6%9E%90.md#%E6%AD%A5%E9%AA%A4-3%E7%94%9F%E6%88%90%E5%9B%9E%E5%A4%8D)

LLM 拿到上述 JSON 数据，将其润色为自然语言：

> “北京今天晴天，气温28°C，湿度45%，适合户外活动。”

---

### 4. 关键优势总结

[](https://github.com/XWS-prog/GIT/blob/main/%E6%88%91%E7%9A%84ai%E8%AE%A4%E8%AF%86/ai%E5%9F%BA%E7%A1%80%E6%A6%82%E5%BF%B5/Agent%20Skill%E7%AE%80%E8%A6%81%E8%A7%A3%E6%9E%90.md#4-%E5%85%B3%E9%94%AE%E4%BC%98%E5%8A%BF%E6%80%BB%E7%BB%93)

- **可扩展**：想增加新能力，只需写一个新 Skill 并注册，无需重训模型。
    
- **可靠性**：执行逻辑由代码保证，比纯 LLM 生成更精确（比如数学计算、时间查询）。
    
- **安全可控**：敏感操作（如发邮件、支付）可封装在 Skill 内，加权限校验，LLM 无法绕过。