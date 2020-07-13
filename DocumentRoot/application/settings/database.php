<?php defined('_ENGINE') or die('Access Denied'); return array (
  'adapter' => 'mysqli',
  'params' => 
  array (
    'host' => 'database',
    'username' => 'root',
    'password' => 'root',
    'dbname' => 'dandoe_se5',
    'charset' => 'UTF8',
    'adapterNamespace' => 'Zend_Db_Adapter',
    'port' => NULL,
  ),
  'isDefaultTableAdapter' => true,
  'tablePrefix' => 'engine4_',
  'tableAdapterClass' => 'Engine_Db_Table',
); ?>