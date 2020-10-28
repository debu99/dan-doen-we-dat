
INSERT IGNORE INTO `engine4_core_menuitems` (`name`, `module`, `label`, `plugin`, `params`, `menu`, `submenu`, `order`) VALUES
('core_admin_main_plugins_sesadvpmnt', 'sesadvpmnt', 'SES - Stripe Payment Gateway Plugin', '', '{"route":"admin_default","module":"sesadvpmnt","controller":"settings"}', 'core_admin_main_plugins', '', 999),
('sesadvpmnt_admin_main_settings', 'sesadvpmnt', 'Global Settings', '', '{"route":"admin_default","module":"sesadvpmnt","controller":"settings"}', 'sesadvpmnt_admin_main', '', 1);