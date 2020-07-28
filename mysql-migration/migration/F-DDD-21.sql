ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
ADD COLUMN `max_participants` INT NULL AFTER `resource_id`;
INSERT INTO `dandoe_se5`.`engine4_core_mailtemplates` (`type`, `module`, `vars`) VALUES ('join_leave_spot_availability', 'sesevent', '[event_title],[event_url]');