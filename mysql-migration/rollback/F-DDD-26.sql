ALTER TABLE `dandoe_se`.`engine4_sesevent_events` 
DROP COLUMN `age_category_to`,
DROP COLUMN `age_category_from`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
DROP COLUMN `additional_costs_description`,
DROP COLUMN `additional_costs_amount`,
DROP COLUMN `is_additional_costs`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
DROP COLUMN `additional_costs_amount_currency`,

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
DROP COLUMN `gender_destribution`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
DROP COLUMN `other_count`,
DROP COLUMN `female_count`,
DROP COLUMN `male_count`;

ALTER TABLE `dandoe_se5`.`engine4_sesevent_events` 
DROP COLUMN `min_participants`;
