<?php
defined('_ENGINE') or die('Access Denied');
return array (
  'default_backend' => 'File',
  'frontend' => 
  array (
    'core' => 
    array (
      'automatic_serialization' => true,
      'cache_id_prefix' => 'Engine4_',
      'lifetime' => '300',
      'caching' => true,
    ),
  ),
  'backend' => array(
    'File' => array(
      'cache_dir' => APPLICATION_PATH . '/temporary/cache'
    )
  )
);
?>
