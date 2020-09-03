ALTER TABLE `dandoe_se5`.`engine4_users` 
DROP COLUMN `is_dummy_user`;
DROP TABLE `dandoe_se5`.`engine4_dummyusers_settings`;

DELETE FROM `dandoe_se5`.`engine4_core_modules` WHERE (`name` = 'dummyusers');
