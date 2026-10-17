/*
 * NPC 脚本: 9300010 富豪先生 (Mr. Moneybags) —— 农历新年活动（收红包换金币）
 * 原型: bms/Script/cny.s  /  bms/cn-script/cny/cny.js
 *
 * 掉落开关：任务 8208
 *   drop_data_global 里有一行：continent=-1, itemid=4031249, questid=8208
 *     8208 未接(0)   -> needQuestItem() 返回 false -> 红包不生成、也不给玩家发包（完全看不到）
 *     8208 进行中(1) -> 掉
 *     8208 已完成(2) -> 不掉
 *   参考 org.gms.client.Character#needQuestItem() 与 MapleMap#spawnDrop()。
 *   注意：必须用 cm.updateQuestCustomData()（会同时改 status），
 *         只用 getQuestRecord().setCustomData() 只写字符串、不动 status，拦不住掉落。
 *
 * 本次修复（原型/上一版存在的问题）：
 *   1. ★「完成了还是会掉落」的根因就在这里：
 *      原逻辑的"已完成"分支里，玩家只要对"要不要再跟我换一次？"点一次"是"，
 *      就立刻 updateQuestCustomData(8208,"ing")；而"进行中"分支只有"交出红包"
 *      才能改回"已完成"。于是「点一下是 → 身上没红包就走人」会让 8208 永久卡在
 *      进行中，掉落再也关不掉。
 *      -> 现在"进行中但身上没有红包"时会明确问一句要不要先停下，
 *         选"是"就置为已完成，掉落立刻关闭。开关不再是"只能开、关不掉"。
 *   2. 对开场白后的"想做这笔交易吗？"回答"否"时，原来的
 *      `mode == 0 && status == 0` 判断不成立（此时 status 已经是 1），
 *      会走 status-- 回到 0，把开场白再播一遍，而不是结束对话。
 *      -> 现在直接礼貌收尾，并且**不改状态**（保持未接 = 不掉红包）。
 *   3. 金额概率表：上一版把掷点范围从 800000 改成 10000（想让爆率高一点），
 *      但档位上限没同步缩放，`rand < 50000` 恒成立，
 *      导致「1 万」和「1000」两档永远抽不到，实际是 99% 都给 10 万。
 *      -> 现在整理成显式表格 REWARD_TABLE，并且**保持现有实际效果不变**；
 *         想恢复原版五档比例的话，把注释里那份表换上去即可。
 */

var step = 0;
// 0 = 刚打开对话（由 8208 的 customData 决定走哪条分支）
// 1 = 未接：已发开场白，等"下一步"
// 2 = 未接：已发"想做这笔交易吗"，等 是/否
// 3 = 已完成：已发"要不要再换一次"，等 是/否
// 4 = 进行中但身上没红包：已发"要不要先停下"，等 是/否

var ITEM_ENVELOPE = 4031249;   // 红包
var QID_SWITCH = 8208;         // 掉落开关任务

// 掷点范围。原版 bms/Script/cny.s 是 800000，档位上限 1 / 99 / 49900 / 150000。
var REWARD_ROLL = 800000;

// 金额概率表：[掷点上限(不含), 金额]，按顺序取第一个 rand < 上限 的档位。
// 现状（沿用你原来的 9300010.js，效果不变）：
//   0            -> 1000 万   (1/10000  = 0.01%)
//   1 ~ 99       -> 100 万    (99/10000 = 0.99%)
//   100 ~ 9999   -> 10 万     (其余全部)
// 也就是「1 万」和「1000」两档目前抽不到（上限 50000/150000 超过了掷点范围）。
// 如果这是有意为之（想让奖励普遍高一点），保持不动即可。
// 如果想恢复原版五档比例（0.01% / 0.99% / 5.24% / 12.51% / 81.25%）：
//   var REWARD_TABLE = [
//       [1,              10000000],
//       [100,             1000000],
//       [624,              100000],
//       [1875,              10000],
//       [REWARD_ROLL,        1000]
//   ];
var REWARD_TABLE = [
    [1, 10000000],
    [100, 1000000],
    [REWARD_ROLL, 100000]
];

var MSG_ABORT = "如果你改变主意了，随时可以再来找我。";

function start() {
    step = 0;
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1) {                 // ESC 关闭对话框
        cm.dispose();
        return;
    }

    var qrVal = cm.getQuestCustomData(QID_SWITCH);
    var isIng = (qrVal == "ing");
    var isEnd = (qrVal == "end");

    // ==================== 未接任务：开场白 -> 接取 ====================
    if (step == 0 && !isIng && !isEnd) {
        step = 1;
        cm.sendNext("农历新年快乐！愿你在猪年里所有的梦想都能实现！2007 年对我来说是非常棒的一年。我靠销售回收的武器和防具发了一笔大财，现在我来到这里，想把我的好运分享给你，顺便向你表达新年的祝福。");
        return;
    }
    if (step == 1) {
        step = 2;
        cm.sendYesNo("讨厌的怪物把所有的#b#t" + ITEM_ENVELOPE + "##k都吃空了。真是可恶的生物！在新年里我迫切需要它们送给家人。我会根据我口袋里的金币数量，花一笔钱向你收购。怎么样？想做这笔交易吗？");
        return;
    }
    if (step == 2) {
        if (mode == 0) {              // 拒绝：保持未接(0)，红包不掉
            cm.sendOk(MSG_ABORT);
            cm.dispose();
            return;
        }
        cm.updateQuestCustomData(QID_SWITCH, "ing");   // 接取 -> 开启掉落
        cm.sendOk("很好……祝你好运！！！");
        cm.dispose();
        return;
    }

    // ==================== 已完成：问要不要再来一轮 ====================
    // 这一步只问，不动状态；只有真的回答"是"才会把掉落打开。
    if (step == 0 && isEnd) {
        step = 3;
        cm.sendYesNo("嘿，很高兴再见到你！怎么样？你又帮我找到更多的 #b#t" + ITEM_ENVELOPE + "##k 了吗？要不要再跟我换一次？");
        return;
    }
    if (step == 3) {
        if (mode == 0) {              // 不来：保持已完成(2)，红包不掉
            cm.sendOk(MSG_ABORT);
            cm.dispose();
            return;
        }
        cm.updateQuestCustomData(QID_SWITCH, "ing");   // 再来一轮 -> 开启掉落
        cm.sendOk("太棒了！听到这个好消息真开心。我在这里等你。");
        cm.dispose();
        return;
    }

    // ==================== 进行中 ====================
    if (step == 0 && isIng) {
        if (cm.haveItem(ITEM_ENVELOPE, 1)) {
            doExchange();
            return;
        }
        // ★ 修复点：身上没有红包时，给一条明确的"停下"出口，
        //   否则 8208 会一直卡在进行中，红包永远掉个不停。
        step = 4;
        cm.sendYesNo("你身上好像还没有 #b#t" + ITEM_ENVELOPE + "##k 吧？要不要我先停一停收购，等你凑到了再来找我？\r\n（停掉之后，怪物就不会再掉红包了）");
        return;
    }
    if (step == 4) {
        if (mode == 0) {              // 不，继续收：保持进行中(1)，红包继续掉
            cm.sendOk("那我就在这儿继续等着~ 打到了 #b#t" + ITEM_ENVELOPE + "##k 记得拿来给我！");
            cm.dispose();
            return;
        }
        cm.updateQuestCustomData(QID_SWITCH, "end");   // 停下 -> 关闭掉落
        cm.sendOk("好的，那我就先停一停。等你想继续的时候再来找我，咱们再开张！");
        cm.dispose();
        return;
    }

    cm.dispose();
}

// 交出红包换金币。做完这一轮就把 8208 置为已完成，掉落随之关闭。
function doExchange() {
    if (!cm.haveItem(ITEM_ENVELOPE, 1)) {
        cm.sendOk("你确定身上有 #b#t" + ITEM_ENVELOPE + "##k 吗？我开出的条件可是全镇最好的！");
        cm.dispose();
        return;
    }

    var mesoReward = rollMeso();

    cm.gainItem(ITEM_ENVELOPE, -1);
    cm.gainMeso(mesoReward);
    cm.updateQuestCustomData(QID_SWITCH, "end");

    if (mesoReward == 10000000) {
        cm.sendOk("天哪！今年是你的幸运年！用一个 #b#t" + ITEM_ENVELOPE + "##k 换到了 10,000,000 金币……我觉得我要胃溃疡了。不过一言既出驷马难追……好好享受你的财富吧！");
    } else if (mesoReward == 1000000) {
        cm.sendOk("#b" + mesoReward + " 金币#k给你的！哇！？我觉得我给得有点太多了，但交易就是交易。我依然很缺 #b#t" + ITEM_ENVELOPE + "##k，所以找到的话请再拿来给我！");
    } else {
        cm.sendOk("#b" + mesoReward + " 金币#k给你的！希望你度过美好的一年。我依然很缺 #b#t" + ITEM_ENVELOPE + "##k，所以找到的话请再拿来给我！");
    }
    cm.dispose();
}

function rollMeso() {
    var r = Math.floor(Math.random() * REWARD_ROLL);
    for (var i = 0; i < REWARD_TABLE.length; i++) {
        if (r < REWARD_TABLE[i][0]) {
            return REWARD_TABLE[i][1];
        }
    }
    return 1000;
}
