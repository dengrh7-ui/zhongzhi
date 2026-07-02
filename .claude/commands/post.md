---
description: 训后数据录入 + 分析 + 下次调整建议
---

执行训后数据录入：

1. **接收用户输入**（格式自由，但必须有）：
   - 每个动作的每组数据（重量×次数×RPE）
   - 训后精神状态 1-10
   - 任何异常感受（关节痛、技术问题等）

2. **写入 `logs/training.jsonl`**：
追加一行 JSON：
```json
{
  "date": "YYYY-MM-DD",
  "day": "胸/肩/背/腿/D5/腿后链",
  "week": "W1",
  "sets": [
    {"ex": "动作名", "w": 数字kg, "r": 次数, "rpe": 数字}
  ],
  "main_lift": "主项名",
  "main_e1rm": 估算1RM,
  "post_mental": 1-10,
  "notes": "异常情况"
}
```

3. **分析输出**：
```
✅ 已记录 {date} {部位}日 训练

📊 主项分析：
   {main_lift}：{每组重量×次×RPE}
   推算 1RM：{e1rm} kg（vs 上次 {prev}，{Δ}）
   神经驱动趋势：{up/stable/down}

📈 容量统计：
   总组数：{total_sets}
   弱项相关组数：{weak_point_sets}（目标 {target}）

🎯 下次该部位训练调整：
   主项：{next_weight} × {next_reps} × {next_sets}
   理由：{基于RPE规则的推导}

   辅助调整：
   {1-3条具体建议}

⚠️ 异常处理：
   {如有关节痛/技术问题的处理}
```

4. **重量调整规则**（参考 CLAUDE.md 第七节）：
- 主项 RPE 比目标低 2+：+2.5kg
- 主项 RPE 比目标低 1：+1.25kg
- 主项 RPE 等于目标：+1.25kg
- 主项 RPE 高 1：维持
- 主项 RPE 高 2+：-1.25kg

5. **更新 `daily.jsonl` 当日记录**：
- 将 `training` 字段填上对应部位
- 不要重写整行，append 新行或 in-place 修改皆可
