-- =========================================================================
-- 0. 清理旧表与数据 (保证幂等性)
-- =========================================================================
DROP TABLE IF EXISTS `npc_beauty_mapping`;
DROP TABLE IF EXISTS `npc_beauty_pool_item`;
DROP TABLE IF EXISTS `npc_beauty_pool`;
DROP TABLE IF EXISTS `npc_beauty_cat`;

-- =========================================================================
-- 1. 创建表结构
-- =========================================================================

-- ① 分类主表（纯粹定义服务类型与模式，不与具体道具绑定）
CREATE TABLE `npc_beauty_cat` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `menu_index` INT NOT NULL COMMENT '菜单显示顺序 (#L0#, #L1#...)',
  `category_name` VARCHAR(50) NOT NULL COMMENT '中文分类名称',
  `beauty_type` ENUM('HAIR', 'FACE', 'SKIN') NOT NULL DEFAULT 'HAIR' COMMENT '核心类型',
  `service_mode` ENUM('HAIR_CHANGE', 'HAIR_COLOR', 'FACE_CHANGE', 'FACE_COLOR', 'SKIN_CHANGE') NOT NULL COMMENT '服务模式',
  `is_random` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0: VIP自选, 1: 普通随机',
  `template_id` INT DEFAULT 2 COMMENT '台词模板 ID',
  `prompt_text` TEXT COMMENT '二级菜单/预览框提示文本',
  `warning_text` TEXT COMMENT '操作前的警告文本',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '开关: 1=启用, 0=停用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='美容美发/整容/美瞳/皮肤主分类表';

-- ② 独立资源池主表
CREATE TABLE `npc_beauty_pool` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `pool_name` VARCHAR(100) NOT NULL COMMENT '资源池标识',
  `category_id` INT NOT NULL COMMENT '关联 npc_beauty_cat.id 外键',
  `gender` TINYINT NOT NULL DEFAULT 0 COMMENT '适用性别: 0=男, 1=女, -1=通用',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '开关: 1=启用, 0=停用',
  INDEX `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='美容独立资源池';

-- ③ 资源池样式明细表
CREATE TABLE `npc_beauty_pool_item` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `pool_id` INT NOT NULL COMMENT '关联 npc_beauty_pool.id',
  `style_id` INT NOT NULL COMMENT '基础样式ID',
  `sort_order` INT DEFAULT 0,
  INDEX `idx_pool_id` (`pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='资源池样式明细表';

-- ④ NPC 与美容池多对多映射表 (★ 核心改动：coupon_item_id 放置在此处)
CREATE TABLE `npc_beauty_mapping` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `npc_id` INT NOT NULL COMMENT '绑定 NPC ID',
  `pool_id` INT NOT NULL COMMENT '关联 npc_beauty_pool.id',
  `coupon_item_id` INT NOT NULL COMMENT '该 NPC 处理此池子时消耗的专属会员卡/道具 ID',
  `sort_order` INT DEFAULT 0 COMMENT '菜单展示顺序',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '开关: 1=启用, 0=禁用',
  INDEX `idx_npc_id` (`npc_id`),
  INDEX `idx_pool_id` (`pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='NPC与美容池映射表';

-- =========================================================================
-- 2. 初始化业务数据
-- =========================================================================
DELETE FROM `npc_beauty_mapping`;
DELETE FROM `npc_beauty_pool_item`;
DELETE FROM `npc_beauty_pool`;
DELETE FROM `npc_beauty_cat`;
DELETE FROM `npc_dialog` WHERE `template_id` = 2 AND `dialog_type` = 'beauty';

-- 2.1 插入高度复用的主分类 (不再包含 coupon_item_id 字段)
INSERT INTO `npc_beauty_cat` (`id`, `menu_index`, `category_name`, `beauty_type`, `service_mode`, `is_random`, `template_id`, `prompt_text`, `warning_text`, `is_active`) VALUES
(1, 0, '剪发 (VIP 优惠券)', 'HAIR', 'HAIR_CHANGE', 0, 2, '我可以帮你改变发型，让它看起来非常棒。选择一个你喜欢的款式吧：', '', 1),
(2, 1, '染发 (VIP 优惠券)', 'HAIR', 'HAIR_COLOR',  0, 2, '我可以彻底改变你的头发颜色。选择你心仪的颜色吧！', '', 1),
(3, 0, '剪发 (普通优惠券-随机)', 'HAIR', 'HAIR_CHANGE', 1, 2, '', '如果使用普通优惠券，你的发型将会随机改变。确定要使用吗？', 1),
(4, 2, '染发 (普通优惠券-随机)', 'HAIR', 'HAIR_COLOR',  1, 2, '', '如果使用普通优惠券，你的头发颜色将会随机改变。确定要使用吗？', 1),
(5, 0, '整容手术 (VIP 优惠券)', 'FACE', 'FACE_CHANGE', 0, 2, '我可以把你的脸变成全新的样子。请仔细挑选一个...', '', 1),
(6, 0, '整容手术 (普通优惠券-随机)', 'FACE', 'FACE_CHANGE', 1, 2, '', '如果使用普通优惠券，你的脸型将会随机变成任意一种... 确定要进行手术吗？', 1),
(7, 0, '皮肤护理 (高级会员卡)', 'SKIN', 'SKIN_CHANGE', 0, 2, '欢迎来到射手村诊所！你想拥有健康紧致的皮肤吗？让我们为你护理吧~', '', 1),
(8, 0, '美瞳镜片 (普通优惠券-随机)', 'FACE', 'FACE_COLOR',  1, 2, '', '如果你使用普通优惠券，你将获得一副随机的隐形眼镜。确定要改变眼睛颜色吗？', 1),
(9, 1, '美瞳镜片 (VIP 优惠券)',     'FACE', 'FACE_COLOR',  0, 2, '用我们的专业仪器，您可以提前看到佩戴效果。您想戴什么样的镜片呢？', '', 1);

-- 2.2 独立资源池
INSERT INTO `npc_beauty_pool` (`id`, `pool_name`, `category_id`, `gender`, `is_active`) VALUES
(1,  'henesys_vip_male_hair',   1,  0, 1),
(2,  'henesys_vip_female_hair', 1,  1, 1),
(3,  'henesys_vip_hair_color',  2, -1, 1),
(4,  'henesys_reg_male_hair',   3,  0, 1),
(5,  'henesys_reg_female_hair', 3,  1, 1),
(6,  'henesys_reg_hair_color',  4, -1, 1),
(7,  'henesys_vip_male_face',   5,  0, 1),
(8,  'henesys_vip_female_face', 5,  1, 1),
(9,  'henesys_reg_male_face',   6,  0, 1),
(10, 'henesys_reg_female_face', 6,  1, 1),
(11, 'henesys_skin_pool',       7, -1, 1),
(12, 'henesys_exp_lens_pool',  8, -1, 1),
(13, 'henesys_vip_lens_pool',  9, -1, 1);

-- 2.3 样式明细注入
INSERT INTO `npc_beauty_pool_item` (`pool_id`, `style_id`, `sort_order`) VALUES
(1, 30030, 1), (1, 30020, 2), (1, 30000, 3), (1, 30480, 4), (1, 30310, 5), (1, 30330, 6), (1, 30060, 7), (1, 30150, 8), (1, 30410, 9), (1, 30210, 10), (1, 30140, 11), (1, 30120, 12), (1, 30200, 13),
(2, 31050, 1), (2, 31040, 2), (2, 31000, 3), (2, 31700, 4), (2, 31150, 5), (2, 31310, 6), (2, 31300, 7), (2, 31160, 8), (2, 31100, 9), (2, 31410, 10), (2, 31030, 11), (2, 31080, 12), (2, 31070, 13),
(4, 30000, 1), (4, 30020, 2), (4, 30030, 3), (4, 30060, 4), (4, 30120, 5), (4, 30140, 6), (4, 30150, 7), (4, 30200, 8), (4, 30210, 9), (4, 30310, 10), (4, 30330, 11), (4, 30410, 12),
(5, 31000, 1), (5, 31030, 2), (5, 31040, 3), (5, 31050, 4), (5, 31080, 5), (5, 31070, 6), (5, 31100, 7), (5, 31150, 8), (5, 31160, 9), (5, 31300, 10), (5, 31310, 11), (5, 31410, 12),
(7, 20000, 1), (7, 20001, 2), (7, 20002, 3), (7, 20003, 4), (7, 20004, 5), (7, 20005, 6), (7, 20006, 7), (7, 20007, 8), (7, 20008, 9), (7, 20012, 10), (7, 20014, 11),
(8, 21000, 1), (8, 21001, 2), (8, 21002, 3), (8, 21003, 4), (8, 21004, 5), (8, 21005, 6), (8, 21006, 7), (8, 21007, 8), (8, 21008, 9), (8, 21012, 10), (8, 21014, 11),
(9, 20000, 1), (9, 20001, 2), (9, 20002, 3), (9, 20003, 4), (9, 20004, 5), (9, 20005, 6), (9, 20006, 7), (9, 20007, 8), (9, 20008, 9), (9, 20012, 10), (9, 20014, 11),
(10, 21000, 1), (10, 21001, 2), (10, 21002, 3), (10, 21003, 4), (10, 21004, 5), (10, 21005, 6), (10, 21006, 7), (10, 21007, 8), (10, 21008, 9), (10, 21012, 10), (10, 21014, 11),
(11, 0, 1), (11, 1, 2), (11, 2, 3), (11, 4, 4);

-- 2.4 绑定 NPC 映射 (★ 核心改动：在 Mapping 表中精确指定每个 NPC 和 Pool 对应的 coupon_item_id)
INSERT INTO `npc_beauty_mapping` (`npc_id`, `pool_id`, `coupon_item_id`, `sort_order`, `is_active`) VALUES
-- 娜塔莉亚 (1012103)
(1012103, 1, 5150001, 1, 1), -- VIP剪发男 -> 消耗射手村剪发VIP卡 5150001
(1012103, 2, 5150001, 2, 1), -- VIP剪发女 -> 消耗射手村剪发VIP卡 5150001
(1012103, 3, 5151001, 3, 1), -- VIP染发   -> 消耗射手村染发VIP卡 5151001

-- 布兰妮 (1012104)
(1012104, 4, 5150000, 1, 1), -- 普通剪发男 -> 5150000
(1012104, 5, 5150000, 2, 1), -- 普通剪发女 -> 5150000
(1012104, 6, 5151000, 3, 1), -- 普通染发   -> 5151000

-- 整容医生 (1052004)
(1052004, 7, 5152001, 1, 1), -- VIP整容男 -> 5152001
(1052004, 8, 5152001, 2, 1), -- VIP整容女 -> 5152001

-- 整容助手 (1052005)
(1052005, 9, 5152000, 1, 1), -- 普通整容男 -> 5152000
(1052005, 10, 5152000, 2, 1),-- 普通整容女 -> 5152000

-- 莱努博士 (9200100)
(9200100, 12, 5152010, 1, 1),-- 普通美瞳 -> 5152010
(9200100, 13, 5152013, 2, 1),-- VIP美瞳   -> 5152013

-- 护士 (1012105)
(1012105, 11, 5153000, 1, 1);-- 皮肤护理 -> 5153000

-- 2.5 写入台词数据
INSERT INTO `npc_dialog` (`npc_id`, `template_id`, `dialog_type`, `dialog_key`, `dialog_text`) VALUES
(1012103, 2, 'beauty', 'beauty_start', '我是娜塔莉亚，这家美发沙龙的店长。如果你有 #b#t5150001##k 或 #b#t5151001##k，就让我来帮你的发型焕然一新吧。请选择你想做的项目：'),
(1012103, 2, 'beauty', 'beauty_success', '瞧瞧！！你觉得怎么样？连我都觉得这是一件伟大的艺术品！哈哈哈哈。如果想要换个新发型的话随时来找我，我保证每次都会让你帅气/漂亮无比！'),
(1012104, 2, 'beauty', 'beauty_start', '我是助手布兰妮。如果你刚好有 #b#t5150000##k 或 #b#t5151000##k，要不要让我来帮你换个发型？'),
(1012104, 2, 'beauty', 'beauty_success', '镜子在后面。你觉得新发型怎么样？我知道这可能不是最潮流的款式，但看起来是不是挺不错的？需要再次改变时随时欢迎光临！'),
(1052004, 2, 'beauty', 'beauty_start', '我们来看看... 我可以把你的脸变成全新的样子。你想试试吗？只要有 #b#t5152001##k，就能拥有你喜欢的脸型。请仔细挑选一个吧...'),
(1052004, 2, 'beauty', 'beauty_success', '好啦，手术已经完成了。自己照照镜子看看吧... 感觉怎么样？连我都觉得这是一件绝妙的艺术品... 哈哈，当对这个新外貌感到腻烦的时候，请随时来找我哦！'),
(1052005, 2, 'beauty', 'beauty_start', '如果使用普通优惠券，你的脸可能会变成任何样子... 确定要使用 #b#t5152000##k 进行整容手术吗？'),
(1052005, 2, 'beauty', 'beauty_success', '好啦，手术已经完成了。自己照照镜子看看吧... 感觉怎么样？连我都觉得这是一件绝妙的艺术品... 哈哈哈哈，当对这个新外貌感到腻烦的时候，请随时来找我哦！'),
(9200100, 2, 'beauty', 'beauty_start', '嗨，你好！我是莱努博士，负责射手村整形外科店的美瞳服务！只要有 #b#t5152010##k 或 #b#t5152013##k，剩下的就放心交给我们吧。每个人最先注视的就是眼睛，我们会帮你找到最适合你的美瞳！请选择你想要使用的卡片：'),
(9200100, 2, 'beauty', 'beauty_success', '嗒哒！快看看！你觉得怎么样？我真心觉得你现在的眼睛看起来棒极了！欢迎下次光临。'),
(1012105, 2, 'beauty', 'beauty_start', '哎呀，你好！欢迎来到射手村诊所！你想拥有像我一样健康紧致的皮肤吗？使用 #b#t5153000##k，让我们为你护理吧~'),
(1012105, 2, 'beauty', 'beauty_success', '镜子在后面，可以好好看看！怎么样？你的皮肤是不是变得像我一样白皙紧致、光彩照人了呢？呵呵呵~ 确信你一定会喜欢。欢迎下次光临~'),
(0, 2, 'beauty', 'no_coupon', '嗯...看起来你好像没有带指定正确的会员卡...真遗憾，没有它我可不能为你服务。非常抱歉。'),
(0, 2, 'beauty', 'machine_error', '非常抱歉。这里的工作机器似乎出了一点小故障。我想现在暂时无法为你进行护理了。请过一会儿再来吧。'),
(0, 2, 'beauty', 'beauty_cancel_start', '好的，我明白了。请考虑清楚，如果还需要改变外貌，随时来找我。'),
(0, 2, 'beauty', 'beauty_cancel_menu', '如果你考虑清楚了随时来找我。'),
(0, 2, 'beauty', 'beauty_error', '非常抱歉。看起来我们在为你改变外貌的过程中遇到了一个小问题。请过一会儿再来吧。')
ON DUPLICATE KEY UPDATE `dialog_text` = VALUES(`dialog_text`);



-- =========================================================================
-- 3. 更新旧表
-- =========================================================================
-- 1. 将 npc_craft_list 重命名为 npc_function_list (或者 npc_service_list)
RENAME TABLE `npc_craft_list` TO `npc_function_list`;

-- 2. 修改表注释并新增 type 字段 (默认给已存在的数据赋 'CRAFT')
ALTER TABLE `npc_function_list`
  COMMENT = 'NPC业务功能类型路由表',
  ADD COLUMN `func_type` VARCHAR(20) NOT NULL DEFAULT 'CRAFT' COMMENT '业务类型: CRAFT(制作), BEAUTY(美容), STAT_RESET(洗点)等' AFTER `npc_id`;

-- 3. （可选）为 (npc_id, func_type) 增加复合唯一索引，防止单个 NPC 重复配置同一种业务
ALTER TABLE `npc_function_list`
  ADD UNIQUE INDEX `uk_npc_func` (`npc_id`, `func_type`);

-- 4. 新增
INSERT INTO `npc_function_list` (`npc_id`, `func_type`) VALUES
(1012103, 'BEAUTY'), -- 娜塔莉亚 (VIP美发/染发)
(1012104, 'BEAUTY'), -- 布兰妮 (普通美发/染发)
(1052004, 'BEAUTY'), -- 医生 (VIP整容)
(1052005, 'BEAUTY'), -- 助手 (普通整容)
(9200100, 'BEAUTY'), -- 莱努博士 (美瞳隐形眼镜)
(1012105, 'BEAUTY')  -- 护士 (皮肤护理)ON DUPLICATE KEY UPDATE `func_type` = VALUES(`func_type`);

