
-- The Stripe Payment Gateway Plugin couldn't be installed the regular way, because significant changes have been made to accept ideal payments
INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `order`) VALUES
('core_admin_main_plugins_sesadvpmnt', 'sesadvpmnt', 'SES - Stripe Payment Gateway Plugin', '', '{"route":"admin_default","module":"sesadvpmnt","controller":"settings"}', 'core_admin_main_plugins', '', 999),
('sesadvpmnt_admin_main_settings', 'sesadvpmnt', 'Global Settings', '', '{"route":"admin_default","module":"sesadvpmnt","controller":"settings"}', 'sesadvpmnt_admin_main', '', 1);

INSERT INTO `dandoe_se5`.`engine4_core_menuitems` (`id`, `name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `enabled`, `custom`, `order`) VALUES ('366', 'sesadvpmnt_admin_main_gateway', 'sesadvpmnt', 'Manage Gateway', '', '{\"route\":\"admin_default\",\"module\":\"payment\",\"controller\":\"gateway\",\"target\":\"_blank\"}', 'sesadvpmnt_admin_main', '', '1', '0', '2');

INSERT INTO `dandoe_se5`.`engine4_core_modules` (`name`, `title`, `description`, `version`, `enabled`, `type`) VALUES ('sesadvpmnt', 'SES - Stripe Payment Gateway Plugin', 'Socialenginesolutions', '5.0.0', '1', 'extra');
