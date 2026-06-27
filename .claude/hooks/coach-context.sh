#!/bin/bash
# 教练 session 启动时输出当前状态摘要

set -euo pipefail

REPO_DIR="${CLAUDE_PROJECT_DIR:-/home/user/zhongzhi}"
DAILY="$REPO_DIR/logs/daily.jsonl"
TRAINING="$REPO_DIR/logs/training.jsonl"
CURRENT_WEEK="$REPO_DIR/plan/current-week.md"

TODAY=$(date +%Y-%m-%d)
WEEKDAY=$(date +%u)  # 1=Mon ... 7=Sun

WEEKDAY_CN=("一" "二" "三" "四" "五" "六" "日")
WEEKDAY_NAME=${WEEKDAY_CN[$((WEEKDAY-1))]}

cat <<EOF

═══════════════════════════════════════════════
🏋️  健美教练 Session 启动 · $TODAY 周$WEEKDAY_NAME
═══════════════════════════════════════════════

📁 教练协议：CLAUDE.md（已锁定身份）
📋 本周状态：plan/current-week.md
📊 历史数据：logs/daily.jsonl ($(wc -l <"$DAILY" 2>/dev/null || echo 0) 条) | logs/training.jsonl ($(wc -l <"$TRAINING" 2>/dev/null || echo 0) 条)

📅 最近 3 天 daily 记录：
$(tail -3 "$DAILY" 2>/dev/null || echo "  (无数据)")

🏋️ 最近 2 次训练：
$(tail -2 "$TRAINING" 2>/dev/null | head -c 800 || echo "  (无数据)")

═══════════════════════════════════════════════
⚡ Claude：请按 CLAUDE.md「五、Session 启动行为」自动输出今日状态摘要。
═══════════════════════════════════════════════

EOF
