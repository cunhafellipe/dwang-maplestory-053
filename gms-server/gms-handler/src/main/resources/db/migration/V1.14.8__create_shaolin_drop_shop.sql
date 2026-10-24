-- 东方神州（少林 / 英语村）商店 + 怪物爆率
--
-- 数据源：
--   · 少林 14 只怪掉落 + 3 个商店：北斗 GMS083 服务端库 `beidou` 的 drop_data / shops / shopitems
--   · 英语村 26 只怪掉落：本地 3305 端口的 `zlh079` 库
-- 对应迁移批次：doc/地图迁移/20261022-东方神州少林迁移.md（24 张地图、26 NPC、40 怪物）
-- 可重复执行：先 DELETE 再 INSERT，不依赖库中已有数据

-- ============================================================ 商店（3 个 NPC）
-- 注意：以下 8 个商品在 053 客户端**没有对应 img 图标**（String 里有名字，客户端 Data 里找不到 Item/Character 图标文件），
--       打开商店时客户端取图标会闪退/掉线，因此**已从 shopitems 中剔除**：
--       9310030: 2330000（Consume/0233 不存在）
--       9310033: 1002625（Cap）、1052113 / 1052110（Longcoat）
--       9310038: 1492006 / 1492005 / 1482006 / 1482005（Weapon）
delete from `shops` where shopid in (9310030, 9310033, 9310038);
INSERT INTO `shops` (`shopid`, `npcid`) VALUES (9310030, 9310030);
INSERT INTO `shops` (`shopid`, `npcid`) VALUES (9310033, 9310033);
INSERT INTO `shops` (`shopid`, `npcid`) VALUES (9310038, 9310038);

delete from `shopitems` where `shopid` in (9310030, 9310033, 9310038);
-- shop 9310030（24 条）
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2070000, 500, 0, 108);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2061004, 50, 0, 120);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2060004, 50, 0, 124);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2030000, 400, 0, 128);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2050003, 300, 0, 132);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2020015, 10200, 0, 144);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2020014, 8100, 0, 148);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2020013, 5600, 0, 152);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2020012, 4500, 0, 156);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2001002, 4000, 0, 160);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2001001, 2300, 0, 164);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2001000, 3200, 0, 168);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2022000, 1650, 0, 172);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2022003, 1100, 0, 176);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2010004, 310, 0, 180);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2010003, 100, 0, 184);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2010001, 106, 0, 188);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2010002, 50, 0, 192);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2010000, 30, 0, 196);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2022071, 250000, 0, 212);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2022061, 150000, 0, 216);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310030, 2000002, 320, 0, 228);
-- shop 9310033（83 条）
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061069, 160000, 0, 116);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061070, 160000, 0, 120);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060072, 160000, 0, 124);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060071, 160000, 0, 128);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060052, 108000, 0, 132);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060050, 108000, 0, 136);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060051, 108000, 0, 140);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051009, 111000, 0, 144);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051008, 111000, 0, 148);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051007, 111000, 0, 152);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041074, 180000, 0, 156);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041075, 180000, 0, 160);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040083, 180000, 0, 164);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040082, 180000, 0, 168);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040061, 114000, 0, 172);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040062, 114000, 0, 176);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040063, 114000, 0, 180);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002180, 100000, 0, 184);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002179, 100000, 0, 188);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002178, 100000, 0, 192);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002177, 100000, 0, 196);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002176, 100000, 0, 200);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061080, 160000, 0, 204);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061081, 160000, 0, 208);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061062, 108000, 0, 212);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061060, 108000, 0, 216);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061064, 108000, 0, 220);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061061, 108000, 0, 224);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060069, 160000, 0, 228);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060070, 160000, 0, 232);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060063, 108000, 0, 236);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060061, 108000, 0, 240);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060065, 108000, 0, 244);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060062, 108000, 0, 248);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041081, 180000, 0, 252);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041082, 180000, 0, 256);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041067, 114000, 0, 260);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041065, 114000, 0, 264);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041069, 114000, 0, 268);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041066, 114000, 0, 272);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040079, 180000, 0, 276);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040081, 180000, 0, 280);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040076, 114000, 0, 284);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040074, 114000, 0, 288);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040073, 114000, 0, 292);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040072, 114000, 0, 296);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002137, 100000, 0, 300);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002135, 100000, 0, 304);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002139, 100000, 0, 308);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002138, 100000, 0, 312);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061047, 120000, 0, 316);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061048, 120000, 0, 320);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051027, 450000, 0, 324);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051024, 450000, 0, 328);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051025, 450000, 0, 332);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051023, 450000, 0, 336);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050037, 450000, 0, 340);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050036, 450000, 0, 344);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050038, 450000, 0, 348);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050035, 450000, 0, 352);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050002, 300000, 0, 356);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050031, 300000, 0, 360);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041051, 120000, 0, 364);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041052, 120000, 0, 368);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002144, 96000, 0, 372);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002143, 96000, 0, 376);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002142, 96000, 0, 380);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002141, 96000, 0, 384);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1092002, 200000, 0, 388);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1092001, 100000, 0, 392);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061084, 180000, 0, 396);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1061083, 180000, 0, 400);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060074, 180000, 0, 404);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1060075, 180000, 0, 408);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051014, 112500, 0, 412);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1051001, 112500, 0, 416);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050021, 112500, 0, 420);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1050000, 112500, 0, 424);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041085, 200000, 0, 428);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1041084, 200000, 0, 432);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040085, 200000, 0, 436);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1040000, 200000, 0, 440);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310033, 1002004, 160000, 0, 444);
-- shop 9310038（27 条）
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1472007, 60000, 0, 120);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1472004, 30000, 0, 124);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1462005, 250000, 0, 128);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1462004, 200000, 0, 132);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1452007, 375000, 0, 136);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1452006, 250000, 0, 140);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1442009, 300000, 0, 144);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1442003, 175000, 0, 148);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1432005, 225000, 0, 152);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1432003, 175000, 0, 156);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1422007, 250000, 0, 160);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1422008, 200000, 0, 164);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1412005, 250000, 0, 168);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1412004, 200000, 0, 172);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1402007, 450000, 0, 176);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1402006, 350000, 0, 180);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1372000, 400000, 0, 184);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1372001, 175000, 0, 188);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1332011, 425000, 0, 192);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1332014, 375000, 0, 196);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1332001, 200000, 0, 200);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1322016, 175000, 0, 204);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1322015, 100000, 0, 208);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1312007, 175000, 0, 212);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1312006, 100000, 0, 216);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1302009, 225000, 0, 220);
INSERT INTO `shopitems` (`shopid`, `itemid`, `price`, `pitch`, `position`) VALUES (9310038, 1302004, 100000, 0, 224);

-- ============================================================ 怪物爆率
-- 少林 14 只怪（9600012~9600025）有掉落数据，源 beidou；英语村 26 只怪（9600037~9600062）见末尾小节。
-- 注：itemid = 0 的行是金币掉落（minimum/maximum_quantity 为金币数量）
delete from `drop_data` where dropperid in (9600012, 9600013, 9600014, 9600015, 9600016, 9600017, 9600018, 9600019, 9600020, 9600021, 9600022, 9600023, 9600024, 9600025, 9600037, 9600038, 9600039, 9600040, 9600041, 9600042, 9600043, 9600044, 9600045, 9600046, 9600047, 9600048, 9600049, 9600050, 9600051, 9600052, 9600053, 9600054, 9600055, 9600056, 9600057, 9600058, 9600059, 9600060, 9600061, 9600062);

-- 9600012
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 0, 447, 715, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1002271, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1002275, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1002285, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1032023, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1040104, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1050064, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1050092, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1051053, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1051082, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1060092, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1072172, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1072178, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1072193, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1072210, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1082129, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1102029, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1382013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1402004, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1442008, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1442017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 1472028, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2000005, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2000006, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2040001, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2040501, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2040902, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2041022, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2043301, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2044001, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2044701, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 2070006, 1, 1, 0, 3000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 4000393, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 4004001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 4006001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 4010001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 4010003, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 4020006, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600012, 4020008, 1, 1, 0, 5000);

-- 9600013
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 0, 614, 976, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1002340, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1032017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1040109, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1040111, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1040115, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1050070, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1050078, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1060098, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1060100, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1060104, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1072156, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1072164, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1072174, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1072208, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1082096, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1082108, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1082111, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1082117, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1082121, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1082126, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1092024, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1102030, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1302032, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1312011, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1442057, 1, 1, 0, 4500);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1452014, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 1462013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2020013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2020015, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2040001, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2040501, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2041013, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2041022, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 2044001, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 4000394, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 4004000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 4004001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 4006001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 4020001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600013, 4020007, 1, 1, 0, 5000);

-- 9600014
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 0, 728, 1173, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1002339, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1040110, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1040111, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1050076, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1050091, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1051056, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1051067, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1051078, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1051096, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1060099, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1060100, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1072212, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1082107, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1082112, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1082116, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1082133, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1332023, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1432007, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 1452013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 2000002, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 2002001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 2020015, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 2041022, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 2044001, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 4000244, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 4000245, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 4000395, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 4004001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 4004004, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600014, 4020003, 1, 1, 0, 5000);

-- 9600015
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 0, 728, 1173, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1002339, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1002403, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1040110, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1040111, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1041117, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1050076, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1050091, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1050092, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1050106, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1051056, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1051067, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1051078, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1051096, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1060099, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1060100, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1061116, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1072206, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1072212, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1082107, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1082112, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1082116, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1082139, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1312015, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1332023, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1432007, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1442013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1442014, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1452013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 1452017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 2020015, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 2040602, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 2041022, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 2044001, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 2044701, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 4000396, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 4004002, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 4006001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 4020003, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600015, 4020008, 1, 1, 0, 5000);

-- 9600016
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 0, 728, 1173, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1002339, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1002403, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1040110, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1040111, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1041117, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1050076, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1050091, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1050092, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1050106, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1051056, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1051067, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1051078, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1051096, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1060099, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1060100, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1061116, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1072206, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1072212, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1082107, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1082112, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1082116, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1082139, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1312015, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1332023, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1432007, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1452013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 1452017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 2020015, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 2040602, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 2041022, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 2044001, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 2044701, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 4000397, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 4004002, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 4020003, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600016, 4020008, 1, 1, 0, 5000);

-- 9600017
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 0, 816, 1322, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1002405, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1002529, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1032017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1040112, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1050102, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1051092, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1051105, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1060101, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1072192, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1072194, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1072204, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1082135, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1082142, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1092026, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1322028, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1332022, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1402005, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1442013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 1462018, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2020013, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2020015, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2040001, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2040901, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2041001, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2041013, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 2043301, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 4000403, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 4004002, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 4004004, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 4010002, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 4010005, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 4130004, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600017, 4130006, 1, 1, 0, 8000);

-- 9600018
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 0, 913, 1461, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1002398, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1002530, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1040111, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1041122, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1050098, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1051092, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1051101, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1060102, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1061121, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1072208, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1072228, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1082158, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1092027, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1332052, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1382035, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 1402016, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2020013, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2040004, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2040302, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2040501, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2040902, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2044702, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290004, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290006, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290024, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290030, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290036, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290044, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290054, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290056, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290066, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290072, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290078, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 2290092, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4000398, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4004001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4004004, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4006001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4010001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4020002, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4020004, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600018, 4130011, 1, 1, 0, 8000);

-- 9600019
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 0, 1565, 2504, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1002377, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1032017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1050103, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1050107, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1072215, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1072221, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1082135, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1082140, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1082151, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1332051, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 1422027, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2040707, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2040805, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2041023, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2043301, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2043801, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2044602, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2044701, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290002, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290009, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290012, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290014, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290034, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290050, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290058, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290062, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290068, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290070, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290086, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 2290090, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 4000406, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 4004001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 4006001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 4010001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 4020001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600019, 4130002, 1, 1, 0, 8000);

-- 9600020
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 0, 1238, 1994, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1002380, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1040121, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1051102, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1060109, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1072215, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1082151, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1302056, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 1322045, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2041004, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2041013, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2041022, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2044201, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2290002, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2290009, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2290034, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2290058, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2290068, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 2290090, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 4000407, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 4004004, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 4006001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 4020002, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 4020006, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600020, 4130009, 1, 1, 0, 8000);

-- 9600021
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 0, 1565, 2504, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1002377, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1032017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1050103, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1050107, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1072215, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1072221, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1082135, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1082140, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1082151, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1332051, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 1422027, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2040602, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2040707, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2040805, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2041023, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2043301, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2043801, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2044602, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290002, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290009, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290012, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290014, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290034, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290050, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290058, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290062, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290068, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290070, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290086, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 2290090, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 4000404, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 4004001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 4006001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 4010001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 4020001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600021, 4130002, 1, 1, 0, 8000);

-- 9600022
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 0, 1451, 2322, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1002377, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1032017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1050103, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1050107, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1072215, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1072221, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1082135, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1082140, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1082151, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1332051, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1422027, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 1442014, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2040805, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2043301, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2044602, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290002, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290009, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290012, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290014, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290034, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290050, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290058, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290062, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290068, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290070, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290086, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 2290090, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 4000405, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 4004001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 4006001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 4010001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 4020001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600022, 4130002, 1, 1, 0, 8000);

-- 9600023
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 0, 1238, 1994, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1002380, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1040121, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1051102, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1060109, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1072215, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1082151, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1302056, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 1322045, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2041004, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2041013, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2044201, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2290002, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2290009, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2290034, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2290058, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2290068, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 2290090, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4000401, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4004001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4004004, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4006001, 1, 1, 0, 10000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4020002, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4020006, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600023, 4130009, 1, 1, 0, 8000);

-- 9600024
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 0, 1451, 2322, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1002377, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1032017, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1050103, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1050107, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1072215, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1072221, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1082135, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1082140, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1082151, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1332051, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1422027, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1442013, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 1442014, 1, 1, 0, 800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2000006, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2022003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2040001, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2040805, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2041022, 1, 1, 0, 450);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2043301, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2044602, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290002, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290009, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290012, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290014, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290034, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290050, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290058, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290062, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290068, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290070, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290086, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 2290090, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 4000402, 1, 1, 0, 500000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 4004001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 4006001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 4010001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 4020001, 1, 1, 0, 5000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600024, 4130002, 1, 1, 0, 8000);

-- 9600025
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 0, 10444, 16710, 0, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1040120, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1041124, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1050097, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1051091, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1051105, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1060109, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1061123, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1072214, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1072222, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1072223, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1072227, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1082135, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1082140, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1082151, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1082158, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1092037, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1302056, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1312030, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1322045, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1332051, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1332052, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1372010, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1382035, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1402035, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1412021, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1422027, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1432030, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1442044, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1452019, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1462015, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 1472053, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2000004, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2000005, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040002, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040005, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040302, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040402, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040502, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040505, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040513, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040516, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040602, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040702, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040705, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040707, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040708, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040802, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2040902, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2041023, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2043801, 1, 1, 0, 1800);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290018, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290019, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290032, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290042, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290059, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290069, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290072, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 2290092, 1, 1, 0, 400);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4004001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4004002, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4004003, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4006000, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4006001, 1, 1, 0, 8000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021000, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021001, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021002, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021003, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021004, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021005, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021006, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021007, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600025, 4021008, 1, 1, 0, 30000);

-- ============================================================ 英语村 26 只怪（9600037~9600062，源 zlh079）
-- 每只怪原数据 3 条：金币 40~99（30%）+ 字母收集品 3994059~3994084（36%）+ 技能书 2381048~2381073（0.5%）。
-- **技能书 2381xxx 本服没有该物品，按用户要求不迁移**，只保留金币与字母收集品。

-- 9600037
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600037, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600037, 3994059, 1, 1, 0, 360000);

-- 9600038
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600038, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600038, 3994060, 1, 1, 0, 360000);

-- 9600039
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600039, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600039, 3994061, 1, 1, 0, 360000);

-- 9600040
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600040, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600040, 3994062, 1, 1, 0, 360000);

-- 9600041
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600041, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600041, 3994063, 1, 1, 0, 360000);

-- 9600042
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600042, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600042, 3994064, 1, 1, 0, 360000);

-- 9600043
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600043, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600043, 3994065, 1, 1, 0, 360000);

-- 9600044
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600044, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600044, 3994066, 1, 1, 0, 360000);

-- 9600045
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600045, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600045, 3994067, 1, 1, 0, 360000);

-- 9600046
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600046, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600046, 3994068, 1, 1, 0, 360000);

-- 9600047
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600047, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600047, 3994069, 1, 1, 0, 360000);

-- 9600048
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600048, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600048, 3994070, 1, 1, 0, 360000);

-- 9600049
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600049, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600049, 3994071, 1, 1, 0, 360000);

-- 9600050
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600050, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600050, 3994072, 1, 1, 0, 360000);

-- 9600051
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600051, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600051, 3994073, 1, 1, 0, 360000);

-- 9600052
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600052, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600052, 3994074, 1, 1, 0, 360000);

-- 9600053
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600053, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600053, 3994075, 1, 1, 0, 360000);

-- 9600054
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600054, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600054, 3994076, 1, 1, 0, 360000);

-- 9600055
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600055, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600055, 3994077, 1, 1, 0, 360000);

-- 9600056
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600056, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600056, 3994078, 1, 1, 0, 360000);

-- 9600057
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600057, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600057, 3994079, 1, 1, 0, 360000);

-- 9600058
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600058, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600058, 3994080, 1, 1, 0, 360000);

-- 9600059
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600059, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600059, 3994081, 1, 1, 0, 360000);

-- 9600060
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600060, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600060, 3994082, 1, 1, 0, 360000);

-- 9600061
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600061, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600061, 3994083, 1, 1, 0, 360000);

-- 9600062
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600062, 0, 40, 99, 0, 300000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9600062, 3994084, 1, 1, 0, 360000);

