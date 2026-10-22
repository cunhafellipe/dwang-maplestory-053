-- gold的商店 9250048

delete from `shops` where shopid = 9250048;
INSERT INTO `shops` (`shopid`, `npcid`) VALUES (9250048, 9250048);


delete from `shopitems` where `shopid` = 9250048;
INSERT INTO `shopitems` ( `shopid`, `itemid`, `price`, `pitch`, `position`) VALUES ( 9250048, 2030000, 400, 0, 3);
INSERT INTO `shopitems` ( `shopid`, `itemid`, `price`, `pitch`, `position`) VALUES ( 9250048, 2002020, 2800, 0, 1);
INSERT INTO `shopitems` ( `shopid`, `itemid`, `price`, `pitch`, `position`) VALUES ( 9250048, 2002021, 2800, 0, 2);

-- 爆率
delete from `drop_data` where dropperid in (9420007, 9420008, 9420009, 9420011, 9420012, 9420013, 9420014);
-- 9420007
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES ( 9420007, 4031723, 1, 1, 4415, 400000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES ( 9420007, 4031725, 1, 1, 4412, 50000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES ( 9420007, 4000307, 1, 1, 0, 400000);


-- 9420008
INSERT INTO `drop_data` ( `dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES ( 9420008, 4000308, 1, 1, 0, 400000);
INSERT INTO `drop_data` ( `dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES ( 9420008, 4031717, 1, 1, 4407, 400000);
INSERT INTO `drop_data` ( `dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES ( 9420008, 4031724, 1, 1, 4412, 50000);

-- 9420009


-- 9420011
INSERT INTO `drop_data` ( `dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9420011, 4000310, 1, 1, 0, 700000);

-- 9420012
INSERT INTO `drop_data` ( `dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9420012, 4000311, 1, 1, 0, 700000);

-- 9420013
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9420013, 4000312, 1, 1, 0, 700000);

-- 9420014
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9420014, 1003195, 1, 1, 0, 30000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9420014, 1003455, 1, 1, 0, 150000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9420014, 1032026, 1, 1, 0, 50000);
INSERT INTO `drop_data` (`dropperid`, `itemid`, `minimum_quantity`, `maximum_quantity`, `questid`, `chance`) VALUES (9420014, 4000390, 1, 1, 0, 999999);

