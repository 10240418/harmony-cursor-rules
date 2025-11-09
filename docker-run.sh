#!/bin/bash

# HarmonyOS 开发规则生成器 - Docker 快速启动脚本

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  HarmonyOS 开发规则生成器 - Docker 版        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}\n"

# 检查 .env 文件
if [ ! -f .env ]; then
    echo -e "${YELLOW}⚠️  未找到 .env 文件${NC}"
    if [ -f env.example ]; then
        echo -e "${BLUE}📝 正在复制 env.example 到 .env${NC}"
        cp env.example .env
        echo -e "${RED}❗ 请编辑 .env 文件，设置你的 API 密钥${NC}"
        echo -e "${YELLOW}   编辑完成后，再次运行此脚本${NC}\n"
        echo -e "${BLUE}配置示例：${NC}"
        echo -e "${GREEN}  AI_PROVIDER=siliconflow${NC}"
        echo -e "${GREEN}  SILICONFLOW_API_KEY=你的密钥${NC}\n"
        exit 1
    else
        echo -e "${RED}❌ 未找到 env.example 文件${NC}"
        exit 1
    fi
fi

# 检查 API 密钥是否已配置
if grep -q "your_api_key_here" .env 2>/dev/null || grep -q "your.*api.*key" .env 2>/dev/null; then
    echo -e "${RED}❌ 检测到 .env 文件中 API 密钥未配置${NC}"
    echo -e "${YELLOW}   请编辑 .env 文件，设置正确的 API 密钥${NC}\n"
    exit 1
fi

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ 未检测到 Docker，请先安装 Docker${NC}"
    echo -e "${BLUE}   macOS: https://docs.docker.com/desktop/install/mac-install/${NC}"
    echo -e "${BLUE}   Windows: https://docs.docker.com/desktop/install/windows-install/${NC}"
    echo -e "${BLUE}   Linux: https://docs.docker.com/engine/install/${NC}\n"
    exit 1
fi

# 检查 Docker Compose 是否安装
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ 未检测到 Docker Compose${NC}"
    echo -e "${BLUE}   请确保 Docker Desktop 已安装或安装 docker-compose${NC}\n"
    exit 1
fi

# 检查 Docker 是否运行
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker 未运行，请先启动 Docker Desktop${NC}\n"
    exit 1
fi

echo -e "${GREEN}✅ Docker 环境检查通过${NC}\n"

# 清理旧容器（如果存在）
if [ "$(docker ps -aq -f name=harmony-cursor-rules)" ]; then
    echo -e "${YELLOW}🧹 正在清理旧容器...${NC}"
    docker-compose down 2>/dev/null || true
fi

# 构建镜像
echo -e "${BLUE}🔨 正在构建 Docker 镜像...${NC}"
echo -e "${YELLOW}   (首次构建可能需要几分钟时间)${NC}\n"

if docker-compose build; then
    echo -e "\n${GREEN}✅ 镜像构建完成${NC}\n"
else
    echo -e "\n${RED}❌ 镜像构建失败${NC}\n"
    exit 1
fi

# 创建输出目录
mkdir -p harmony_cursor_rules/final_cursor_rules
echo -e "${GREEN}✅ 输出目录已创建${NC}\n"

# 运行容器
echo -e "${BLUE}🚀 正在启动容器并运行爬虫...${NC}"
echo -e "${YELLOW}   请耐心等待，任务可能需要几分钟...${NC}\n"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

if docker-compose up; then
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "\n${GREEN}🎉 任务完成！${NC}"
    echo -e "${BLUE}📁 生成的规则文件位于: ${GREEN}./harmony_cursor_rules/final_cursor_rules/${NC}\n"
    
    # 列出生成的文件
    if [ -d "harmony_cursor_rules/final_cursor_rules" ]; then
        echo -e "${BLUE}📋 生成的文件列表：${NC}"
        ls -lh harmony_cursor_rules/final_cursor_rules/*.md 2>/dev/null | awk '{print "   - " $9}' || echo "   (暂无文件)"
    fi
    
    echo -e "\n${GREEN}✨ 使用提示：${NC}"
    echo -e "${BLUE}   1. 将 final_cursor_rules 目录中的 .md 文件内容${NC}"
    echo -e "${BLUE}   2. 复制到您的 HarmonyOS 项目的 .cursorrules 文件中${NC}\n"
else
    echo -e "\n${RED}❌ 任务执行失败${NC}"
    echo -e "${YELLOW}   请检查日志输出查找错误原因${NC}\n"
    exit 1
fi

# 清理容器
echo -e "${BLUE}🧹 正在清理容器...${NC}"
docker-compose down

echo -e "\n${GREEN}✅ 所有操作完成！${NC}\n"
