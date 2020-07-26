<?php

 /**
 * socialnetworking.solutions
 *
 * @category   Application_Modules
 * @package    Sesandroidapp
 * @copyright  Copyright 2014-2019 Ahead WebSoft Technologies Pvt. Ltd.
 * @license    https://socialnetworking.solutions/license/
 * @version    $Id: Slides.php 2018-08-14 00:00:00 socialnetworking.solutions $
 * @author     socialnetworking.solutions
 */


class Sesandroidapp_Model_DbTable_Slides extends Engine_Db_Table {
	protected $_rowClass = "Sesandroidapp_Model_Slide";

  public function getSlides($status = false,$params=array()) {
    $tableName = $this->info('name');
    $select = $this->select();
    $select->from($tableName);
	  $select ->order('order ASC');
	  if($status)
			$select = $select->where('status = 1');
      $select->where('type !=?',1);
    if(!empty($params['fetchAll'])){
      return $this->fetchAll($select);  
    }
    return Zend_Paginator::factory($select);
  }
}
