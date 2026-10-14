/*
 * NPC 脚本: 欧庞果 / VersalNatal 礼物兑换 (pongo_present)
 * 对应任务 ID: 4997
 * 对应道具 ID: 4031443 (10-20级), 4031440 (21-30级), 4031441 (31-40级), 4031439 (41-60级), 4031442 (61级+)
 */

var status = -1;
var selectedMenu = -1;

function start() {
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1) {
        cm.dispose();
        return;
    }

    if (mode == 0) {
        if (status == 0) {
            cm.dispose();
            return;
        }
        status--;
    } else {
        status++;
    }

    // 活动时间检查（2007年11月20日至2008年1月15日）
    var cal = java.util.Calendar.getInstance();
    var year = cal.get(java.util.Calendar.YEAR);
    var month = cal.get(java.util.Calendar.MONTH) + 1;
    var day = cal.get(java.util.Calendar.DAY_OF_MONTH);

//    if (year < 2007 || (year == 2007 && month < 11) || (year == 2007 && month == 11 && day < 20)) {
//        cm.sendOk("还不是圣诞节哦！");
//        cm.dispose();
//        return;
//    }
//    if (year > 2008 || (year == 2008 && month > 1) || (year == 2008 && month == 1 && day > 15)) {
//        cm.sendOk("圣诞节已经结束了。");
//        cm.dispose();
//        return;
//    }

    var val1 = cm.getQuestStatus(4997);

    if (status == 0) {
        cm.sendSimple("我被称为 O-Pongo（欧庞果），VersalNatal 的小老鼠！有什么我可以帮你的吗？\r\n" +
            "#b#L0#你可以跟我多讲讲关于VersalNatal的事吗？VersalNatal 是什么样的？#l\r\n" +
            "#L1#你觉得这些礼物怎么样，O-Pongo？我在那些可怕的怪物身上找到了很多。#l\r\n" +
            "#L2#我有厚厚一堆礼物要交给你，O-Pongo，准备好让它们Versal化了！#l#k");
    } else if (status == 1) {
        selectedMenu = selection;

        if (selectedMenu == 0) {
            // 分支 0：讲述故事（支持多页对话）
            if (status == 1) {
                cm.sendNext("好吧，年轻的朋友！我来给你讲个故事！\r\nVersal 并不是一直被阴影笼罩的。很久很久以前，在它变成今天这样之前，这里只是洋葱田野间的普通维萨尔村庄。太阳每天都照耀着大地……\r\n(点击下一步继续收听 VersalNatal 的古老传说)");
            }
        } else if (selectedMenu == 1) {
            // 分支 1：解释礼物与活动规则
            cm.sendNext("礼物！我最喜欢礼物了！让我看看……\r\n(检查发现是普通的红蓝药水或箭矢)\r\n哎呀！这些MapleNatal的礼物可没那么神奇，有点太无聊和实用啦！孩子们可不喜欢这些。Ho-Ho-Ho！我有个计划，用我的魔杖把它们转化成真正的VersalNatal礼物！");
        } else if (selectedMenu == 2) {
            // 分支 2：提交礼物逻辑
            if (val1 == 2) {
                cm.sendOk("你今年决定庆祝 MapleNatal 了，对吧？我想你应该把这些礼物带给 Miau Noel（猫咪圣诞老人）……她正等着你呢。");
                cm.dispose();
            } else {
                var presentId = getPlayerPresentId(cm.getPlayer().getLevel());

                // 这里调用原脚本对应的 GivePresent2 逻辑（通常在此处会调用数量选择框，如 10, 20, 30... 现简化为调用核心兑换接口或提示）
                cm.sendOk("系统检测到你当前等级对应的任务礼物道具 ID 为：#b#t" + presentId + "##k。\r\n(请在服务端实现具体的批量兑换交互逻辑，例如使用 cm.sendGetNumber 或判定背包内道具数量后执行兑换)\r\n #r当前还未实现 --DWANG#k");
                cm.dispose();
            }
        }
    } else if (status == 2 && selectedMenu == 0) {
        // 故事后续段落
        cm.sendNext("随着村子繁荣，巨兽因贪婪吞吃了太阳，世界陷入黑暗……最终勇士们战胜了巨兽，释放了太阳！但太阳由于在巨兽肚子里呆过而变弱了，只能每年发光99天。这就是VersalNatal（维萨尔圣诞）的由来！");
        cm.dispose();
    } else if (status == 2 && selectedMenu == 1) {
        // 规则后续段落
        cm.sendOk("怪物携带的礼物颜色取决于你的等级：\r\n- 10-20级：#b红色和绿色礼物#k\r\n- 21-30级：#b红色和白色礼物#k\r\n- 31-40级：#b红色和蓝色礼物#k\r\n- 41-60级：#b蓝色和白色礼物#k\r\n- 61级以上：#b绿色和白色礼物#k\r\n每交 10 个礼物可以产生 1 个 #bVersalNatal快乐宝珠#k！快去收集吧！");
        cm.dispose();
    }
}

// 根据玩家等级匹配对应礼物的函数
function getPlayerPresentId(level) {
    if (level >= 10 && level <= 20) {
        return 4031443; // 红绿礼物
    } else if (level >= 21 && level <= 30) {
        return 4031440; // 红白礼物
    } else if (level >= 31 && level <= 40) {
        return 4031441; // 红蓝礼物
    } else if (level >= 41 && level <= 60) {
        return 4031439; // 蓝白礼物
    } else {
        return 4031442; // 绿白礼物 (61级以上)
    }
}