# v0.53 服务端→客户端 包头（收包 opcode）审计

审计对象：`org.gms.net.opcodes.SendPacketOpcode`（053 段，0x00 ~ 0xFFFF）
审计依据：`GMSv53.exe.i64`（IDA，imagebase 0x400000）+ 053 客户端 StringPool 文案 +
`MapleStory.exe.i64`(v0.95 全符号) / `Angel.exe`(v0.83 全符号) 交叉比对。

---

## 0. 结论速览

你把 39 处区间标成「未使用」，实际只有 **14 处是真空白**；
其余 **25 处、共 57 个 opcode 客户端都有处理器**（有些还是完整实现，只是服务端从来不发）。

> 也就是说：不是「没补充名字」，而是「这些编号本身是有效包，名字写错了/漏了」。

---

## 1. 客户端收包分派链（这是判断"有没有处理器"的唯一标准）

```
CClientSocket::ProcessPacket            0x46AD00   Decode2 取 opcode
 ├ 0x03 OnMigrateCommand                           0x46AE16   (=v83 0x10)
 ├ 0x09 OnAliveReq                                 0x46ADD3   (=v83 0x11, PING)
 ├ 0x0A OnAuthenCodeChanged                        0x46AEF7   (=v83 0x12)
 ├ 0x0B OnAuthenMessage                            0x46B072   (=v83 0x13)
 ├ 0x10 CSecurityClient::OnPacket                  0x795194   (=v83 0x14)
 ├ 0x14 OnCheckCrcResult                           0x46B0C8   (=v83 0x19)
 ├ 0x18..0x4C  -> CWvsContext::OnPacket            0x76A69B
 └ 其它        -> CStage::OnPacket                 0x600541
                   ├ CLogin::OnPacket              0x533288   (stage=login)
                   ├ CField::OnPacket              0x4D1861   (stage=field)
                   └ CCashShop::OnPacket           0x459032   (stage=cashshop)

CField::OnPacket 再按区间转给各 Pool：
  0x50..0x64 场内包（另有 0xD5/0xD6/0xD7/0xD8/0xDB/0xDC/0xDD/0xE5 显式 case）
  101..149 -> CUserPool::OnPacket   0x707A46  (102..111 CUserLocal 0x6F4837 / 113..131 CUser / 132..148 CUserRemote)
  150..166 -> CMobPool::OnPacket    0x58E000  (0x97..0xA3 -> OnMobPacket 0x58E052)
  167..175 -> CNpcPool::OnPacket    0x5A3132  (168..170 OnNpcTemplatePacket 0x5A3317 / 173..174 OnNpcPacket 0x5A3282)
  176..180 -> CReactorPool          0x5DECF7  (只 0xB2/0xB3/0xB4)
  181..183 -> CEmployeePool         0x4BD5DA  (0xB5/0xB6/0xB7)
  184..185 -> CDropPool             0x4B44CA
  186..188 -> CMessageBoxPool       0x577D82
  189..190 -> CAffectedAreaPool     0x421AFA
  191..192 -> COpenGatePool         0x620687
  193..195 -> CScriptMan            0x5EA71F  (只 0xC2 -> OnScriptMessage)
  214..215 -> CShopDlg              0x5F1C1F
  246..248 -> CFuncKeyMappedMan     0x4F62C3  (0xF6/0xF7/0xF8)
  251..256 -> CMapleTVMan           0x55B521  (只 0xFC/0xFD/0xFE)
```
---

## 2. 57 个「被标未使用、其实有处理器」的 opcode

### 2.1 登录段（CLogin::OnPacket 0x533288 / ProcessPacket）

| opcode | 客户端处理器 | 作用 | 置信度 |
|---|---|---|---|
| 0x01 | 0x533CC8 | 只 DecodeStr 存进 CLogin+0x190（游客ID/推荐世界文本） | 中 |
| 0x02 | 0x534E76 | 查看全部角色结果，文案 3654 找不到角色 / 3655 已连接 / 3656 未知错误 | 高 |
| 0x04 | 0x5353EF | 游戏服地址（GoToGameServer），与 0x0C 同一份实现 | 高 |
| 0x0A | 0x46AEF7 | 认证码变更：Decode1 flags + Decode4；bit1 弹网吧/Win98 提示(363/364)，bit2 抛 CDisconnectException | 中 |
| 0x0B | 0x46B072 | 认证消息：Decode4 + Decode1 -> sub_77E1E7 | 中 |
| 0x0E | 0x53633F | 选角结果：Decode1 槽位 + Decode1 结果，成功后发 COutPacket(0x03) 迁移包 | 中 |
| 0x0F | 0x53645B | 关窗后 Decode1，失败弹 "Try Again!" | 中 |
| 0x10 | 0x795194 | 安全客户端（HackShield 类）：Decode1 子类型 0/2/3 | 中 |
| 0x11 | 0x5367FC | Decode1 失败弹 CLoginUtilDlg::Error(15) | 中 |
| 0x14 | 0x46B0C8 | CRC 校验应答：Decode2 条数 + 22*条数字节，回 COutPacket(0x12) | 中 |

### 2.2 CWvsContext 段（CWvsContext::OnPacket 0x76A69B）

| opcode | 客户端处理器 | 作用 | 置信度 |
|---|---|---|---|
| 0x1A | 0x7806B9 | OnClearAvatarMegaphone（与 v95 完全同构，整包无字段） | 高 |
| 0x1B | 0x7806D5 | Decode1 flag；Notice(507 改名申请已提交) / Notice(3240) / DecodeStr 后 Notice | 中 |
| 0x1D | 0x77DC0C | 防外挂答题窗口（推测 OnAntiMacroResult）：Decode1 类型，type=4 再 Decode2+Decode2+Decode1 | 中 |
| 0x20 | 0x77E399 | 举报结果（新版）：3060-3076 每周剩余次数/举报理由/只能 %d~%d 举报 | 高 |
| 0x21 | 0x77E5F6 | Decode1+Decode1 写 +10828/+10829（就是 0x20 用的举报时间窗，≈v83 CLAIM_AVAILABLE_TIME） | 中 |
| 0x22 | 0x779367 | CharacterData + Decode1+Decode1，再重分配物品槽 ZArray | 低 |
| 0x28 | 0x78581B | OnGuildResult：323-351 / 2953-2974 / 3215-3219 全部公会消息 | 高 |
| 0x2E | 0x77E7FB | 雇佣商人/仓库检查：3145/3146/3147/3149/3170 + 167/168 | 中 |
| 0x30 | 0x779C31 | 只清 +2080、写 +2081=当前时间，Decode1 丢弃（ExclRequest 时间戳） | 中 |
| 0x34 | 0x77FA2F | OnSueCharacterResult（旧版举报）：2701-2705 | 高 |
| 0x36 | 0x77BC97 | OnTradeMoneyLimit：3642 15 级以下每天 100 万 | 高 |
| 0x37 | 0x77BC7E | Decode1 写 +2059（与 CLogin 0x0E 同一成员） | 低 |
| 0x3B | 0x77EB02 | OnIncubatorResult：3109 背包满 / 3110 猪猪蛋出物品 | 高 |
| 0x3C | 0x77F239 | 3295 "找不到你输入的物品"（检索/商店扫描类） | 中 |
| 0x3D | 0x77F508 | 单例窗口 + sub_68802F（全客户端下载链接/外链） | 低 |
| 0x3E | 0x77FB7C | OnMarriageRequest：3376 "%s 向你求婚" | 高 |
| 0x3F | 0x77FCDD | OnMarriageResult：3378-3427 全部婚约结果码 | 高 |
| 0x40 | 0x78037D | Decode1 类型 9/10/0xB~0x10 -> sub_74BB8B / sub_74D4E1（婚礼窗口） | 中 |
| 0x41 | 0x77126E | 单例 dword_8842D8 + sub_64A4FA（伴侣地图转移类） | 低 |
| 0x42 | 0x76A9D3 | Decode4 写 +2695 | 低 |
| 0x43 | 0x77F53E | OnCashPetFoodResult：3510 宠物不能吃 | 高 |
| 0x44 | 0x778C5A | OnSetAvatarMegaphone：Decode1+DecodeStr 存 +11524，状态栏显示 | 中 |
| 0x45 | 0x778CE5 | Decode1 写 +2883 | 低 |
| 0x47 | 0x7803B8 | Decode1 结果码，走 sub_74BB8B / sub_74D4E1 | 低 |
| 0x48 | 0x780421 | OnAvatarMegaphoneRes：3463 需 10 级 / 3637 排队 15 秒 | 高 |
| 0x49 | 0x78077C | OnCancelTransferWorldResult：3685 | 高 |
| 0x4A | 0x78083E | OnDestroyShopResult：3140 GM 关店 | 高 |
| 0x4B | 0x76A9E9 | 只 Decode1 丢弃（占位包） | 高 |

### 2.3 场内段

| opcode | 客户端处理器 | 作用 | 置信度 |
|---|---|---|---|
| 0x5A | 0x4D1D58 | CField::OnTransferChannelReqIgnored（换频道被拒） | 高 |
| 0x5B | 0x4D1EE1 | 纯虚转发，用全局 dword_881960 当 opcode | 高 |
| 0x6E | 0x6FC8E2 | 有 case 但处理器是空函数（nullsub） | 高 |
| 0x76 | 0x6179E1 | 召唤兽同步（sub_6E5E14 case 118） | 中 |
| 0x78 | 0x6E76A0 | 只 Decode4 | 中 |
| 0x79 | 0x6E5BFA | Decode1+Decode4+DecodeStr+5×Decode1（气泡/留言） | 中 |
| 0x7B | 0x6E507B | Decode1+DecodeStr（文字气泡/黑板） | 中 |
| 0x7E | 0x6E5DA0→vtbl+0x1C | 宠物与主人互动虚函数 | 中 |
| 0x88 | 0x712A4C | 只 Decode4（远处玩家单值状态） | 低 |
| 0x8E | 0x6E8015 | CUser::SetActiveEffectItem（Decode4 道具ID） | 高 |
| 0x8F | 0x714AEB | DecodeStr | 低 |
| 0x90 | 0x7128E5 | Decode4+3×Decode1 | 低 |
| 0x94 | 0x714B36 | Decode2+Decode1+Decode2+Decode1 | 低 |
| 0x99 | 0x586D13 | Decode1 -> sub_583A8D；v83 对应位 0xF1 已删除（废弃包） | 中 |
| 0x9E | 0x586EF0 | Decode4 + 文本 -> sub_5F59EE/sub_40E890（怪物说话） | 中 |
| 0xA0 | 0x5862CF | Decode1 开关 + Variant（怪物身上道具特效） | 中 |
| 0xA2 | 0x586444 | Decode4+Decode2+当前时间 -> 计时器（与 v83 0xF5 代码逐行一致） | 高 |
| 0xA3 | 0x586FA0 | Decode4 -> sub_583AE7 | 中 |
| 0xAE | 0x5A0A80 | CNpc::OnSetSpecialAction | 高 |
---

## 3. 确认为「真空白」的 opcode（客户端完全没有处理器）

判断标准：不属于 ProcessPacket 的任何 case，且所在 Pool 的 switch 里也没有对应 case。

| opcode | 证据 |
|---|---|
| 0x16、0x17 | ProcessPacket 无 case；落到 CStage->CLogin::OnPacket 也没有 |
| 0x1E | CWvsContext::OnPacket 无 case 0x1E |
| 0x2C | CWvsContext::OnPacket 无 case 0x2C |
| 0x35 | CWvsContext::OnPacket 无 case 0x35 |
| 0x39 | CWvsContext::OnPacket 无 case 0x39 |
| 0x46 | CWvsContext::OnPacket 无 case 0x46 |
| 0x69 | CUserLocal::OnPacket(0x6F4837) 无 case 0x69（v83 对应 0xD0 也空） |
| 0x83 | CUser::OnPetPacket 只到 0x82 |
| 0x95 | OnUserRemotePacket 只到 148 |
| 0x9F、0xA1 | CMobPool::OnMobPacket 无对应 case |
| 0xA6 | CMobPool::OnPacket 只到 0xA5 |
| 0xA8、0xAA | CNpcPool::OnNpcTemplatePacket(0x5A3317) 只处理 0xA9 |
| 0xAF、0xB0、0xB1 | 0xAF 不在任何区间；CReactorPool 只处理 0xB2/0xB3/0xB4 |
| 0xC1、0xC3、0xC4 | CScriptMan::OnPacket(0x5EA71F) 只处理 0xC2 |
| 0xC4 ~ 0xD4 | CField 只把 193..195 给 CScriptMan、214..215 给 CShopDlg；196..213 无人分发 |
| 0xDE ~ 0xE4、0xE6 ~ 0xEB | 同上（232..235 无人分发） |
| 0xEF ~ 0xF5 | CField 只把 246..248 给 CFuncKeyMappedMan；239..245 无人分发 |
| 0xF9、0xFA、0xFB | 见下 |

### 关于 0xF9 ~ 0xFB（你举的例子）

```
CField::OnPacket @0x4D1861：
    if (opcode >= 251 && opcode <= 256)
        CMapleTVMan::OnPacket(opcode, packet);      // 0x55B521

CMapleTVMan::OnPacket @0x55B521：
    case 0xFC: OnSetMessage          (0x55B568)
    case 0xFD: OnClearMessage        (0x55B554)
    case 0xFE: OnSendMessageResult   (0x55B752)
```

所以：
- **0xF9(249)、0xFA(250)**：CField 根本不转发（不在 251..256 内）→ 无处理器
- **0xFB(251)**：会转给 CMapleTVMan，但里面没有 case 0xFB → 等于无处理器

结论：`0xF9 - 0xFB 未使用` 这条批注 **是对的**，可以在注释里直接写"无处理器"。

---

## 4. 额外发现（超出「未使用」范围，建议顺手核对）

1. **0x04 与 0x0C 是同一份实现**（0x5353EF / 0x5356B9，都是 GoToGameServer：inet_addr + ntohs + 连接）。
   你的 `SERVER_IP(0x0C)` 没错，但 0x04 也是同一个包（第二个入口），现在被标成"未使用"。
2. **0x62 CONTI_MOVE / 0x63 CONTI_STATE 在 0x53 客户端里没有 case**（CField::OnPacket 只有 0x61 的虚调用和 0x64 的 sub_4D6FE8）。
   如果服务端发过 0x62/0x63，客户端会直接丢弃。
3. **0xFFFF UPDATE_CHAR_BOX**：CField::OnPacket 的区间表里没有 0xFFFF，整条链上也没有 case，
   即当前客户端不会处理 0xFFFF。v0x83 里 CHAR_BOX 是别的编号，需要单独确认。
4. **怪物段（0x97~0xA3）有错位风险**：v0x83 的 mob switch 是 0xEF move / 0xF0 ctrlAck / 0xF2 statSet /
   0xF3 statReset / 0xF6 damaged / 0xFC effectByItem / 0xFD mobSpeaking，而 v053 多了 0x99（v83 已删）等。
   我逐行比对确认 0xA2 与 v83 0xF5 代码完全一致，但 0x9C/0x9D/0x9E 与 v83 0xF4/0xF5/0xF6 的对应还没锁死。
   建议实测：发 0x9D 看客户端是否出伤害数字、发 0x98 看是否只是控制应答。

---

## 5. 我在 IDA 里做的改动

新增 29 个函数符号（`W` 方式命名，与现有 `CWvsContext__OnXxx` 风格一致）+ 31 条入口注释：

```
CClientSocket__OnMigrateCommand            0x46AE16
CClientSocket__OnAliveReq                  0x46ADD3
CClientSocket__OnAuthenCodeChanged         0x46AEF7
CClientSocket__OnAuthenMessage             0x46B072
CSecurityClient__OnPacket                  0x795194
CClientSocket__OnCheckCrcResult            0x46B0C8
CLogin__OnGuestIDLogin_or_WorldMsg         0x533CC8
CLogin__OnViewAllCharResult                0x534E76
CLogin__OnCreateNewCharacterResult         0x534475
CLogin__OnDeleteCharacterResult            0x5342B8
CWvsContext__OnClearAvatarMegaphone        0x7806B9
CWvsContext__OnSetAvatarMegaphone          0x778C5A
CWvsContext__OnAvatarMegaphoneRes          0x780421
CWvsContext__OnAntiMacroResult             0x77DC0C
CWvsContext__OnReportCharacterResult       0x77E399
CWvsContext__OnSueCharacterResult          0x77FA2F
CWvsContext__OnGuildResult                 0x78581B
CWvsContext__OnIncubatorResult             0x77EB02
CWvsContext__OnMarriageRequest             0x77FB7C
CWvsContext__OnMarriageResult              0x77FCDD
CWvsContext__OnCashPetFoodResult           0x77F53E
CWvsContext__OnCancelTransferWorldResult   0x78077C
CWvsContext__OnDestroyShopResult           0x78083E
CWvsContext__OnTradeMoneyLimit             0x77BC97
CEmployeePool__OnEmployeeEnterField        0x4BD60D
CEmployeePool__OnEmployeeLeaveField        0x4BD6AA
CEmployeePool__OnEmployeeMiniRoomBalloon   0x4BD708
CNpcPool__OnNpcImitateData                 0x5A31BA
CNpcPool__OnNpcTemplate                    0x5A6A37
```

IDB 已保存。

---

## 6. Java 端改动

`SendPacketOpcode.java`：39 处「未使用」批注全部改写，新增 23 个常量（命名与北斗段冲突的加 `_053` 后缀）：

```
VIEW_ALL_CHAR_RESULT(0x02)          SERVER_IP_2(0x04)
AUTHEN_CODE_CHANGED(0x0A)           AUTHEN_MESSAGE(0x0B)
SELECT_CHARACTER_RESULT(0x0E)       SECURITY_CLIENT(0x10)
CHECK_CRC_RESULT_053(0x14)          CLEAR_AVATAR_MEGAPHONE_053(0x1A)
ANTI_MACRO_RESULT(0x1D)             REPORT_CHARACTER_RESULT(0x20)
GUILD_RESULT(0x28)                  ENTRUSTED_SHOP_CHECK_RESULT_053(0x2E)
SUE_CHARACTER_RESULT_053(0x34)      TRADE_MONEY_LIMIT_053(0x36)
INCUBATOR_RESULT_053(0x3B)          MARRIAGE_REQUEST_053(0x3E)
MARRIAGE_RESULT_053(0x3F)           CASH_PET_FOOD_RESULT_053(0x43)
SET_AVATAR_MEGAPHONE_053(0x44)      AVATAR_MEGAPHONE_RESULT_053(0x48)
CANCEL_TRANSFER_WORLD_RESULT_053(0x49)  DESTROY_SHOP_RESULT_053(0x4A)
TRANSFER_CHANNEL_REQ_IGNORED(0x5A)  NPC_SET_SPECIAL_ACTION(0xAE)
```

（其余有处理器但语义未锁死的 opcode，只加了「地址 + 解码顺序 + 推测」的分行注释，没有硬命名，避免误导。）
已用 javac 单文件编译验证通过（无重复常量名、括号配平）。