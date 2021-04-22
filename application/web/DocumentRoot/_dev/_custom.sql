UPDATE `engine4_core_menuitems` SET `enabled` = '0'
WHERE `engine4_core_menuitems`.`name` = 'sesevent_profile_share';

ALTER TABLE `engine4_sesevent_events` ADD `change_title_count` INT(10) DEFAULT 0 AFTER `save_count`;

INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `enabled`, `custom`, `order`)
VALUES ('sesevent_profile_copy', 'sesevent', 'Copy This Event', 'Sesevent_Plugin_Menus', '', 'sesevent_profile', '', 1, 0, 6);

INSERT IGNORE INTO `engine4_activity_notificationtypes`
    (`type`, `module`, `body`, `is_request`, `handler`, `default`, `sesandoidapp_enable_pushnotification`)
VALUES ('sesevent_new_event_on_region', 'sesevent', 'New event {item:$object} on your region.', 0, '', 1, 1),
       ('sesevent_last_minute_event_on_region', 'sesevent', 'Event {item:$object} last minute on your region.', 0, '', 1, 1),
       ('sesevent_new_online_event', 'sesevent', 'New online event {item:$object}.', 0, '', 1, 1),
       ('sesevent_last_minute_online_event', 'sesevent', 'Online event {item:$object} last minute.', 0, '', 1, 1);

drop table if exists `engine4_user_regions`;
create table `engine4_user_regions`
(
    `region_id`    int(11) unsigned not null auto_increment primary key,
    `region_title` varchar(128) not null
);

insert ignore into `engine4_user_regions` (`region_title`) values
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
('sesevent_new_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1),
('sesevent_last_minute_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1),
('sesevent_new_online_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1),
('sesevent_last_minute_online_event', 'sesevent', '[host],[email],[recipient_title],[recipient_link],[recipient_photo],[sender_title],[sender_link],[sender_photo],[object_title],[object_link],[object_photo],[object_description]',1);

alter table `engine4_sesevent_events` add `region_id` int(10) after `location`;