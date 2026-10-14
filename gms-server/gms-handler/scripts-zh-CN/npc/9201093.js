/*
 * NPC 脚本: 丢单补发 / 苏茜的失物 (suzy_lost)
 * 对应任务 ID: 4994, 4997, 4998
 * 道具 ID: 4031877 (任务道具/心愿清单)
 */

var status = -1;

function start() {
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1) {
        cm.dispose();
        return;
    }

    if (mode == 0) {
        cm.dispose();
        return;
    } else {
        status++;
    }

    // 活动时间检查（2007年11月20日至2008年1月15日）
    // 如果服务端不需要强行判断时间，可以直接注释掉时间戳校验部分
    var cal = java.util.Calendar.getInstance();
    var year = cal.get(java.util.Calendar.YEAR);
    var month = cal.get(java.util.Calendar.MONTH) + 1;
    var day = cal.get(java.util.Calendar.DAY_OF_MONTH);


    var val1 = cm.getQuestStatus(4994); // 0: 未接, 1: 进行中, 2: 已完成
    var val2 = cm.getQuestStatus(4997);
    var val3 = cm.getQuestStatus(4998);

    if (status == 0) {
        if (val1 == 0 || val1 == 1) {
            cm.sendSimple("这是什么？\r\n#b#L0#算了吧。我弄错了。#l");
        } else if (val1 == 2) {
            if (val2 == 2 || val3 == 2) {
                cm.sendSimple("你已经完成了，不需要我的心愿单哦。");
            } else {
                // 检查玩家身上是否已经有道具 4031877
                if (cm.haveItem(4031877, 1)) {
                    cm.sendSimple("这是什么？\r\n#b#L0#算了吧。我弄错了。#l");
                } else {
                    // 玩家没有该道具，触发补发逻辑
                    if (status == 0) {
                        cm.sendNext("你这话什么意思？啊，你不会吧……你把我给你的心愿清单弄丢了吗？我还以为大人不会像我一样丢三落四呢！");
                    }
                }
            }
        }
    } else if (status == 1) {
        // 如果玩家在前面的菜单点了选项 0，直接关闭
        if (selection == 0) {
            cm.dispose();
            return;
        }

        // 补发道具
        if (!cm.canHold(4031877, 1)) {
            cm.sendOk("你的其他栏（ETC）背包空间满了。");
            cm.dispose();
            return;
        }

        var success = cm.gainItem(4031877, 1);
        if (!success) {
            cm.sendOk("你的其他栏（ETC）背包空间满了。");
        } else {
            cm.sendNext("给，我又为你重新写了一份。这次请千万不要再弄丢了！");
        }
        cm.dispose();
    }
}