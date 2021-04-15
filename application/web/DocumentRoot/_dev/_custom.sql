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