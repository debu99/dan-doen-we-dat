UPDATE `engine4_core_menuitems` SET `enabled` = '0'
WHERE `engine4_core_menuitems`.`name` = 'sesevent_profile_share';

ALTER TABLE `engine4_sesevent_events` ADD `change_title_count` INT(10) DEFAULT 0 AFTER `save_count`;

INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `enabled`, `custom`, `order`)
VALUES ('sesevent_profile_copy', 'sesevent', 'Copy This Event', 'Sesevent_Plugin_Menus', '', 'sesevent_profile', '', 1, 0, 6)
