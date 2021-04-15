UPDATE `engine4_core_menuitems` SET `enabled` = '0'
WHERE `engine4_core_menuitems`.`name` = 'sesevent_profile_share';

ALTER TABLE `engine4_sesevent_events` ADD `change_title_count` INT(10) DEFAULT 0 AFTER `save_count`;

INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `enabled`, `custom`, `order`)
VALUES ('sesevent_profile_copy', 'sesevent', 'Copy This Event', 'Sesevent_Plugin_Menus', '', 'sesevent_profile', '', 1, 0, 6)

-- 2021-04-15
INSERT INTO `engine4_core_pages` (`name`, `displayname`, `url`, `title`, `description`, `keywords`, `custom`, `fragment`, `layout`, `levels`, `provides`, `view_count`) VALUES
('ememsub_settings_index', 'User Subscription Page', NULL, 'Subscription', '', '', 0, 0, '', NULL, 'no-subject', 0);

INSERT INTO `engine4_core_content` (`page_id`, `type`, `name`, `parent_content_id`, `order`, `params`, `attribs`) VALUES
((SELECT page.page_id FROM engine4_core_pages  page WHERE page.NAME = 'ememsub_settings_index'), 'container', 'main', NULL, 1, '[""]', NULL);
INSERT INTO `engine4_core_content` (`page_id`, `type`, `name`, `parent_content_id`, `order`, `params`, `attribs`)
SELECT page.page_id, 'container', 'middle', content.content_id, 1, '[""]', NULL
FROM engine4_core_pages page JOIN engine4_core_content content ON page.page_id = content.page_id
WHERE page.NAME='ememsub_settings_index' AND content.NAME='main';