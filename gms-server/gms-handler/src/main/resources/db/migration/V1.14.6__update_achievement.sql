-- 减负任务成就
UPDATE achievement_discount_config SET max_progress = 600, name = '系统任务', weight_percent = 10, enabled = 1, is_accumulate = 1 WHERE category = 'QUEST_COMPLETED';