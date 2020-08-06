ALTER TABLE `dandoe_se`.`engine4_sesevent_events` 
DROP COLUMN `max_participants`;
DELETE FROM `dandoe_se`.`engine4_core_mailtemplates` WHERE (`mailtemplate_id` = '78');