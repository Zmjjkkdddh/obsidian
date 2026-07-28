---
tags:
  - AI
  - LLM
  - 基础概念
created: 2026-07-28
---

# Token 是什么

**Token** 是 LLM 处理文本的**最小单位**——模型不是按"字"或"词"理解文本的，而是按 Token。

## Token 划分规则

- **英文**：1 Token ≈ 0.75 个单词（4 个字符 ≈ 1 Token）
- **中文**：1 个汉字 ≈ 1.5~2 个 Token
- Token 不一定是完整词，可以是子词（BPE 算法切分）

### 举例

| 文本 | Token 数 |
|------|----------|
| `Hello World` | 2 |
| `unbelievable` | `un` + `believe` + `able` = 3 |
| `人工智能` | 约 3~4 |

## 为什么 Token 重要？

| 维度 | 影响 |
|------|------|
| **计费** | API 按 Token 收费（输入 + 输出） |
| **上下文窗口** | 模型一次能处理的最大 Token 数 |
| **速度** | Token 越多 → 生成越慢 |
| **成本** | Token 越多 → 费用越高 |

## Tokenizer 工具

- [OpenAI Tokenizer](https://platform.openai.com/tokenizer) — 在线可视化
- `tiktoken` — OpenAI 官方 Python 库

---

📚 关联：[[LLM大语言模型]] | [[上下文窗口]]
