UPDATE `engine4_core_menuitems` SET `enabled` = '0'
WHERE `engine4_core_menuitems`.`name` = 'sesevent_profile_share';

ALTER TABLE `engine4_sesevent_events` ADD `change_title_count` INT(10) DEFAULT 0 AFTER `save_count`;

INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `enabled`, `custom`, `order`)
VALUES ('sesevent_profile_copy', 'sesevent', 'Copy This Event', 'Sesevent_Plugin_Menus', '', 'sesevent_profile', '', 1, 0, 6);

-- 2021-04-15
INSERT INTO `engine4_core_pages` (`name`, `displayname`, `url`, `title`, `description`, `keywords`, `custom`, `fragment`, `layout`, `levels`, `provides`, `view_count`) VALUES
('ememsub_settings_index', 'User Subscription Page', NULL, 'Subscription', '', '', 0, 0, '', NULL, 'no-subject', 0);

INSERT INTO `engine4_core_content` (`page_id`, `type`, `name`, `parent_content_id`, `order`, `params`, `attribs`) VALUES
((SELECT page.page_id FROM engine4_core_pages  page WHERE page.NAME = 'ememsub_settings_index'), 'container', 'main', NULL, 1, '[""]', NULL);
INSERT INTO `engine4_core_content` (`page_id`, `type`, `name`, `parent_content_id`, `order`, `params`, `attribs`)
SELECT page.page_id, 'container', 'middle', content.content_id, 1, '[""]', NULL
FROM engine4_core_pages page JOIN engine4_core_content content ON page.page_id = content.page_id
WHERE page.NAME='ememsub_settings_index' AND content.NAME='main';

INSERT IGNORE INTO `engine4_activity_notificationtypes`
    (`type`, `module`, `body`, `is_request`, `handler`, `default`, `sesandoidapp_enable_pushnotification`)
VALUES ('sesevent_new_event', 'sesevent', 'Event {item:$object} has been created.', 0, '', 1, 1),
       ('sesevent_last_minute_event', 'sesevent', 'Event {item:$object} will be started soon.', 0, '', 1, 1),
       ('sesevent_new_online_event', 'sesevent', 'Event {item:$object} has been created.', 0, '', 1, 1),
       ('sesevent_last_minute_online_event', 'sesevent', 'Event {item:$object} will be started soon.', 0, '', 1, 1);

drop table if exists `engine4_user_regions`;
create table `engine4_user_regions`
(
    `region_id`   int(11) unsigned not null auto_increment primary key,
    `title`       varchar(128) not null
);

insert ignore into `engine4_user_regions` (`title`) values
('Noord-Holland'),
('Zuid-Holland'),
('Zeeland'),
('Noord-Brabant'),
('Utrecht'),
('Flevoland'),
('Friesland'),
('Groningen'),
('Drenthe'),
('Overijssel'),
('Gelderland'),
('Limburg');

drop table if exists `engine4_user_regionvalues`;
create table `engine4_user_regionvalues` (
     `regionvalue_id` int(11) unsigned not null auto_increment primary key,
     `region_id` int(11) unsigned not null,
     `user_id` int(11) unsigned not null
);


insert ignore into `engine4_core_mailtemplates` (`type`, `module`, `vars`, `default`) values
('notify_sesevent_new_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1),
('notify_sesevent_last_minute_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1),
('notify_sesevent_new_online_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1),
('notify_sesevent_last_minute_online_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1);

alter table `engine4_sesevent_events` add `region_id` int(10) after `location`;

/* update type 128 characters for engine4_user_emailsettings */
alter table `engine4_user_emailsettings` change column `type` `type` varchar(128);

/* add task to send mail for last minute event */
insert ignore into `engine4_core_tasks` (`title`, `module`, `plugin`, `timeout`)
values ('Last Minute Event Mail', 'sesevent', 'Sesevent_Plugin_Task_LastMinuteMail', 43200);
