<?php defined('_ENGINE') or die('Access Denied'); return array (
  'adapter' => 'mysqli',
  'params' => 
  array (
    'host' => getenv('db_host'),
    'username' => getenv('db_username'),
    'password' => getenv('db_password'),
    'dbname' => getenv('db_database'),
    'charset' => 'UTF8',
    'adapterNamespace' => 'Zend_Db_Adapter',
    'port' => NULL,
  ),
  'isDefaultTableAdapter' => true,
  'tablePrefix' => 'engine4_',
  'tableAdapterClass' => 'Engine_Db_Table',
); ?>