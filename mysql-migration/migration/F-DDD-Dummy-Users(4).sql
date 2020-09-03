ALTER TABLE `dandoe_se5`.`engine4_users` 
ADD COLUMN `is_dummy_user` TINYINT(1) NULL AFTER `friendsCount`;

CREATE TABLE `dandoe_se5`.`engine4_dummyusers_settings` (
  `id` INT NOT NULL,
  `is_enabled` TINYINT(1) NULL,
  `amount_dummy_users` INT(11) NULL,
  PRIMARY KEY (`id`));

INSERT IGNORE INTO `engine4_core_modules` (`name`, `title`, `description`, `version`, `enabled`, `type`) VALUES  ('dummyusers', 'Dummy Users', 'Creates 1000 dummy users with a profile.', '4.0.0', 1, 'extra') ;

INSERT INTO `dandoe_se5`.`engine4_dummyusers_settings` (`id`, `is_enabled`, `amount_dummy_users`) VALUES ('1', '0', '1000');

INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `order`) VALUES
('core_admin_main_plugins_dummyusers', 'dummyusers', 'Dummy Users', '', '{"route":"admin_default","module":"dummyusers","controller":"settings","action":"index"}', 'core_admin_main_plugins', '', 999),
('dummyusers_admin_main_settings', 'dummyusers', 'Global Settings', '', '{"route":"admin_default","module":"dummyusers","controller":"settings"}', 'dummyusers_admin_main', '', 1);
