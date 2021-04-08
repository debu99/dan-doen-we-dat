UPDATE `engine4_core_menuitems` SET `enabled` = '0'
WHERE `engine4_core_menuitems`.`name` = 'sesevent_profile_share';

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