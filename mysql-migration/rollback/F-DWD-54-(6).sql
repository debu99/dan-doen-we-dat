ALTER TABLE `dandoe_se5`.`engine4_activity_notificationtypes` 
CHANGE COLUMN `type` `type` VARCHAR(32) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL ;

ALTER TABLE `dandoe_se5`.`engine4_activity_notificationsettings` 
CHANGE COLUMN `type` `type` VARCHAR(32) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL ;
