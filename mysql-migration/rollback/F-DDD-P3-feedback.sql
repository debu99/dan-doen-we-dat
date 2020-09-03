ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
DROP COLUMN `tel_host`,
DROP COLUMN `meeting_time`,
DROP COLUMN `meeting_point`;

DELETE FROM `dandoe_se5`.`engine4_core_menuitems` WHERE (`id` = '360');
DELETE FROM `dandoe_se5`.`engine4_core_menuitems` WHERE (`id` = '361');
