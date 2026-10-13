/*
 * 全能数据驱动美容/美发/整容/皮肤通用中文 NPC 脚本
 * 完美契合 OdinMS 经典 sendStyle 交互流程与数据库架构
 */

var status = -1;
var selectedCategoryIndex = -1;
var selectedCategory = null;
var optionsList = null;
var dialogMap = null;

// 校验外观是否可用，完美模拟原版的 pushIfItemExists
function pushIfItemExists(array, itemId) {
    var cosmeticId = cm.getCosmeticItem(itemId);
    if (cosmeticId != -1 && !cm.isCosmeticEquipped(cosmeticId)) {
        array.push(cosmeticId);
    } else if (cosmeticId == -1) {
        // 如果 cm.getCosmeticItem 未实现或返回原值，直接压入兜底
        array.push(itemId);
    }
}

// 统一台词读取（优先从数据库 npc_dialog 取，没有则取默认）
function getDialog(key, defaultText) {
    if (dialogMap != null && dialogMap.get(key) != null) {
        return dialogMap.get(key) + "";
    }
    return defaultText;
}

function start() {
    status = -1;
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode < 1) {
        if (status == 0) {
            cm.sendNext(getDialog("beauty_cancel_start", "好的，如果有需要再来找我。"));
        } else {
            cm.sendNext(getDialog("beauty_cancel_menu", "如果你考虑清楚了随时来找我。"));
        }
        cm.dispose();
        return;
    }

    status++;

    // -------------------------------------------------------------------------
    // Status 0: 加载菜单并展示
    // -------------------------------------------------------------------------
    if (status == 0) {
        var playerGender = cm.getPlayer().getGender();
        dialogMap = cm.getNpcBeautyDialogs(cm.getNpc());

        var menuList = cm.getNpcBeautyMenuList(cm.getNpc(), playerGender);
        if (menuList == null || menuList.isEmpty()) {
            cm.sendOk("该服务台暂未配置适用于你当前性别的项目或正在维护中。");
            cm.dispose();
            return;
        }

        // 如果只有一个选项（如皮肤护理），直接模拟选择第 0 项
//        if (menuList.size() == 1) {
//            selectedCategoryIndex = menuList.get(0).getMenuIndex();
//            selectedCategory = cm.getBeautyCategoryData(cm.getNpc(), selectedCategoryIndex, playerGender);
//
//            status = 1; // 直接跳到处理逻辑
//            action(1, 0, selectedCategoryIndex);
//            return;
//        }

        // 多个选项（如娜塔莉亚的理发与染发），弹出菜单
        var selStr = getDialog("beauty_start", "我是这家店的负责人。请选择你想要进行的项目：#b");
        for (var i = 0; i < menuList.size(); i++) {
            var menu = menuList.get(i);
            selStr += "\r\n#L" + menu.getMenuIndex() + "# "+ "#v" + menu.getCouponItemId() + "#" + "#t" + menu.getCouponItemId() + "#"  + menu.getCategoryName() +"#l";
        }
        cm.sendSimple(selStr);

    // -------------------------------------------------------------------------
    // Status 1: 玩家选择了项目，弹出 sendStyle 预览框 或 sendYesNo 随机确认框
    // -------------------------------------------------------------------------
    } else if (status == 1) {
        if (selectedCategoryIndex == -1) {
            selectedCategoryIndex = selection;
        }

        var playerGender = cm.getPlayer().getGender();
        selectedCategory = cm.getBeautyCategoryData(cm.getNpc(), selectedCategoryIndex, playerGender);

        if (selectedCategory == null || selectedCategory.getOptions() == null || selectedCategory.getOptions().isEmpty()) {
            cm.sendOk("当前项目暂无可用的样式。");
            cm.dispose();
            return;
        }

        var rawOptions = selectedCategory.getOptions();
        optionsList = [];

        // 遍历并进行过滤
        for (var i = 0; i < rawOptions.size(); i++) {
            pushIfItemExists(optionsList, rawOptions.get(i));
        }

        if (optionsList.length == 0) {
            cm.sendOk("没有适合你当前状态的外观变化项目。");
            cm.dispose();
            return;
        }

        var isRandom = selectedCategory.isRandom();

        if (isRandom) {
            // 普通卡/EXP卡：随机模式弹出 YesNo 确认框
            var warningText = selectedCategory.getWarningText();
            if (warningText == null || (warningText + "").length == 0) {
                warningText = "如果使用普通优惠券，你的外观将会随机改变。确定要使用吗？";
            }
            cm.sendYesNo(warningText);
        } else {
            // VIP自选模式：调用经典 cm.sendStyle 弹出预览窗口
            var promptText = selectedCategory.getPromptText();
            if (promptText == null || (promptText + "").length == 0) {
                promptText = "我可以帮你改变外观。选择一个你喜欢的款式吧：";
            }
            cm.sendStyle(promptText, optionsList);
        }

    // -------------------------------------------------------------------------
    // Status 2: 玩家在 sendStyle 中点击了选中项，或者在 YesNo 中点了“是”，进行实际扣费和修改
    // -------------------------------------------------------------------------
    } else if (status == 2) {
        var couponId = selectedCategory.getCouponItemId();
        var beautyType = selectedCategory.getBeautyType() + ""; // HAIR, FACE, SKIN
        var isRandom = selectedCategory.isRandom();

        // 1. 检查优惠券/道具
        if (!cm.haveItem(couponId, 1)) {
            var noCouponMsg = getDialog("no_coupon", "嗯...看起来你没有我们指定的优惠券...恐怕我不能为你服务。对不起...");
            cm.sendOk(noCouponMsg);
            cm.dispose();
            return;
        }

        // 2. 决定最终要应用的外观 ID
        var targetStyleId = -1;
        if (isRandom) {
            // 随机抽取一个
            var randIndex = Math.floor(Math.random() * optionsList.length);
            targetStyleId = optionsList[randIndex];
        } else {
            // VIP 自选：selection 即为玩家在 sendStyle 窗口选中的数组索引
            if (selection >= 0 && selection < optionsList.length) {
                targetStyleId = optionsList[selection];
            }
        }

        if (targetStyleId == -1) {
            cm.sendOk(getDialog("beauty_error", "非常抱歉，外貌更新过程中出现了异常。"));
            cm.dispose();
            return;
        }

        // 3. 执行扣券与外观设置（模拟原版逻辑）
        cm.gainItem(couponId, -1);

        if (beautyType == "HAIR") {
            cm.setHair(targetStyleId);
        } else if (beautyType == "FACE") {
            cm.setFace(targetStyleId);
        } else if (beautyType == "SKIN") {
            cm.setSkin(targetStyleId); // 设置肤色
        }

        // 4. 成功提示台词
        var successMsg = getDialog("beauty_success", "享受你的新外貌吧！欢迎下次光临~");
        cm.sendOk(successMsg);
        cm.dispose();
    }
}