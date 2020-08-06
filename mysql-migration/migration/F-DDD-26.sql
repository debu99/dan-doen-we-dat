ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
ADD COLUMN `age_category_from` INT NULL AFTER `max_participants`,
ADD COLUMN `age_category_to` INT NULL AFTER `age_category_from`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
ADD COLUMN `is_additional_costs` TINYINT NULL DEFAULT 0 AFTER `age_category_to`,
ADD COLUMN `additional_costs_amount` FLOAT NULL DEFAULT 0 AFTER `is_additional_costs`,
ADD COLUMN `additional_costs_description` TEXT NULL AFTER `additional_costs_amount`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
ADD COLUMN `additional_costs_amount_currency` VARCHAR(45) NULL AFTER `additional_costs_description`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
ADD COLUMN `gender_destribution` VARCHAR(44) NULL DEFAULT "Undistributed" AFTER `additional_costs_amount`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
ADD COLUMN `male_count` INT(11) UNSIGNED NOT NULL AFTER `gender_destribution`,
ADD COLUMN `female_count` INT(11) UNSIGNED NOT NULL AFTER `male_count`,
ADD COLUMN `other_count` INT(11) UNSIGNED NOT NULL AFTER `female_count`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
ADD COLUMN `min_participants` INT(11) NULL DEFAULT 0 AFTER `resource_id`;
