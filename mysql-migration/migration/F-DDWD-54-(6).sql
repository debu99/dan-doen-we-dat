ALTER TABLE `dandoe_se5`.`engine4_activity_notificationtypes` 
CHANGE COLUMN `type` `type` VARCHAR(80) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL ;


UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'sesevent_event_adminpaymentapprove' WHERE (`type` = 'sesevent_event_adminpaymentappro');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'sesevent_event_adminpaymentcancel' WHERE (`type` = 'sesevent_event_adminpaymentcance');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'notify_sescredit_approve_upgrade_request' WHERE (`type` = 'notify_sescredit_approve_upgrade');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'notify_sescredit_reject_upgrade_request' WHERE (`type` = 'notify_sescredit_reject_upgrade_');

UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'sesevent_event_adminpaymentapprove' WHERE (`type` = 'sesevent_event_adminpaymentappro');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'sesevent_event_adminpaymentcancel' WHERE (`type` = 'sesevent_event_adminpaymentcance');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'notify_sescredit_approve_upgrade_request' WHERE (`type` = 'notify_sescredit_approve_upgrade');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'notify_sescredit_reject_upgrade_request' WHERE (`type` = 'notify_sescredit_reject_upgrade_');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'sesmembershipswitch_changenotifi' WHERE (`type` = 'sesmembershipswitch_level_changenotifi');
UPDATE `dandoe_se5`.`engine4_activity_notificationtypes` SET `type` = 'sesmembershipswitch_notification' WHERE (`type` = 'sesmembershipswitch_level_notification');

ALTER TABLE `dandoe_se5`.`engine4_activity_notificationsettings` 
CHANGE COLUMN `type` `type` VARCHAR(80) CHARACTER SET 'latin1' COLLATE 'latin1_general_ci' NOT NULL ;
