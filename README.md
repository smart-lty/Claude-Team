<div align="center">

<table border="0">
<tr>
<td width="150" align="center">
<img src="figures/logo.png" alt="CLAUDE Team Logo" width="120"/>
</td>
<td>

# Claude-Team

**Claude × Codex × Gemini = 超级生产力**

</td>
</tr>
</table>

[![Claude](https://img.shields.io/badge/Claude-Code-D97757?logo=anthropic&logoColor=fff)](https://claude.ai)
[![Codex](https://img.shields.io/badge/OpenAI-Codex-412991?logo=openai&logoColor=fff)](https://openai.com)
[![Gemini](https://img.shields.io/badge/Google-Gemini_CLI-886FBF?logo=googlegemini&logoColor=fff)](https://ai.google.dev)

⭐ **觉得有帮助？给我们一个 Star 吧！** 您的每一个 Star 都是我们前进的动力 🚀

**[⚡️ 快速开始](#快速开始) · [🎬 Demo 演示](#demo-演示)**

**中文** | [English](README_EN.md)

</div>

---

## 💡 Claude-Team 项目简介

还在多个AI工具间疲于奔命？论文读不完、代码写不动、数据理不清……**Claude-Team** 为你组建一支7×24待命的AI梦之队：

- **📖 Claude**：深度理解与全局统筹，负责阅读长文、撰写论文、协调团队
- **💻 Codex**：代码实现与调试专家，从算法原型到生产级代码一气呵成
- **🔍 Gemini**：超长文本处理专家，分析代码仓库、扫描千行日志、研读海量文档

你只需一个入口提出需求，三位AI自动分工协作，将完整结果呈现眼前。**从此告别工具切换，专注伟大构想。**

<div align="center">
<img src="figures/work.png" alt="Claude-Team 工作流程" width="100%"/>
</div>

---

## 🎬 Demo 演示

<div align="center">
  

https://github.com/user-attachments/assets/f8eae51e-93bc-4e81-80a1-748b1c4aea70



*实际使用演示：看 Claude-Team 如何协调三个 AI 完成任务*

</div>

---

## 🚀 快速开始

### 步骤 1：安装 AI CLI 工具

```bash
# 1. 安装 Claude Code（必需）
npm install -g @anthropic-ai/claude-code

# 2. 安装 Codex 或 Gemini（至少选一个，两个都装更好）
npm install -g @openai/codex         # 代码实现与调试专家
npm install -g @google/gemini-cli    # 超长文本处理专家（需要 Node.js 20+）
```

**验证安装：**

```bash
claude --version
codex --version    # 如果安装了 Codex
gemini --version   # 如果安装了 Gemini
```

**更多资源**：
- 📚 [Claude Code 官方文档](https://github.com/anthropics/claude-code)
- 📚 [OpenAI Codex 官方文档](https://github.com/openai/codex)
- 📚 [Gemini CLI 官方文档](https://github.com/google-gemini/gemini-cli)

---

### 步骤 2：配置 CLI 工具

#### 配置 Claude Code

```bash
claude # 按照提示完成认证
```


#### 配置 Codex（如果已安装）

```bash
codex # 选择 "Sign in with ChatGPT" 或使用 API 密钥
```

#### 配置 Gemini CLI（如果已安装）

```bash
gemini # 选择 "Login with Google" 或使用 API 密钥
```

> **提示**：测试每个工具是否能正常对话，确认配置成功后再进行下一步。

> **推荐**：没有 Codex 和 Claude Code 的官方付费账号？来试试这两个中转站！<br> 
Codex: [codexzh.com](https://codexzh.com/?ref=D181A8)  <br>
Claude Code: [ccodezh.com](https://ccodezh.com/)
---

### 步骤 3：配置 Claude-Team 协作环境

```bash
git clone https://github.com/smart-lty/Claude-Team.git
cd Claude-Team
bash setup.sh
```

配置脚本会自动完成：检测已安装工具 → 配置 MCP 服务器 → 安装协作模板 → 验证环境

---

### 步骤 4：开始使用

```bash
# 启动 Claude Code
claude

# Claude 会根据任务自动调用 Codex 或 Gemini，例如：
> "分析这个代码仓库的架构"          # 可能调用 Gemini
> "帮我实现一个快速排序算法"        # 可能调用 Codex
> "分析 logs/training.log 中的错误" # 可能调用 Gemini
```

**工作原理**：您只需和 Claude 对话，它会自动决定何时调用 Codex 或 Gemini，三个 AI 无缝协作。

---

## 🙏 致谢

本项目的实现离不开以下优秀的开源项目和服务：
- **[Claude Code](https://github.com/anthropics/claude-code)** - Anthropic 提供的强大 AI 编程助手
- **[OpenAI Codex](https://github.com/openai/codex)** - OpenAI 的代码生成和调试专家
- **[Gemini CLI](https://github.com/google-gemini/gemini-cli)** - Google 的超长文本处理利器
- **[codexmcp](https://github.com/GuDaStudio/codexmcp)** - 为 Claude Code 提供 Codex 集成的 MCP 服务器
- **[gemini-mcp-tool](https://github.com/jamubc/gemini-mcp-tool)** - 为 Claude Code 提供 Gemini 集成的 MCP 服务器

### 设计资源

- **Logo 和配图** 由 [Nano Banana Pro](https://www.anthropic.com/) 生成

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给我们一个 Star！**

Made with ❤️ for researchers

---

*本项目 README 由 Claude-Team 生成*

</div>
