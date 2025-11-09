# HarmonyOS 开发规则生成器

自动爬取华为官方 HarmonyOS 开发文档，智能提取最佳实践并生成 Cursor IDE 开发规则。

详细介绍：https://mp.weixin.qq.com/s/gLgP7gGU0pmGc2x1hS-0UQ

## 🚀 快速开始

### 使用 Docker（推荐）

```bash
# 1. 配置 API 密钥
cp env.example .env
# 编辑 .env 文件，设置 AI_PROVIDER 和 API 密钥

# 2. 运行
./docker-run.sh
```

### 本地 Python 环境

```bash
# 1. 安装依赖
pip install -r Requirements.txt

# 2. 配置 API 密钥
cp env.example .env
# 编辑 .env 文件

# 3. 运行
python main.py
```

## ⚙️ 配置说明

编辑 `.env` 文件：

```bash
# 使用 SiliconFlow（推荐，国内可直接访问）
AI_PROVIDER=siliconflow
SILICONFLOW_API_KEY=你的密钥

# 或使用 Gemini
AI_PROVIDER=gemini
GEMINI_API_KEY=你的密钥
```

**获取 SiliconFlow API 密钥：**
1. 访问 https://siliconflow.cn 注册
2. 进入 https://cloud.siliconflow.cn/account/ak 创建密钥

## 📁 输出结果

生成的规则文件位于：`harmony_cursor_rules/final_cursor_rules/`

将生成的 `.md` 文件内容复制到你的 HarmonyOS 项目的 `.cursorrules` 文件中即可使用。

## 🐳 Docker 命令参考

```bash
# 一键运行
./docker-run.sh

# 或手动运行
docker-compose up --build

# 后台运行
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止
docker-compose down

# 调试模式
docker-compose run --rm harmony-crawler python main.py --debug
```

## 📚 功能特性

- ✅ 智能爬取华为官方 HarmonyOS 文档
- ✅ 支持多种 AI 模型（Gemini / SiliconFlow）
- ✅ 自动提取最佳实践和开发规范
- ✅ 生成 ArkTS Lint 规则
- ✅ Docker 一键部署

## 🔧 配置文件

- `env.example` - 环境变量模板
- `harmony_modules_config.json` - 爬取模块配置
- `docker-compose.yml` - Docker 编排配置

## 📖 参考文档

- [HarmonyOS 界面开发最佳实践](https://developer.huawei.com/consumer/cn/doc/best-practices/bpta-ui-dynamic-operations)
- [TypeScript 到 ArkTS 迁移指南](https://developer.huawei.com/consumer/en/doc/harmonyos-guides-V14/typescript-to-arkts-migration-guide-V14)

---

*基于 AI 自动化提取华为官方文档，为 HarmonyOS 开发者提供专业的开发规范指导*
