<?php

/**
 * SocialEngineSolutions
 *
 * @category   Application_Sespwa
 * @package    Sespwa
 * @copyright  Copyright 2018-2019 SocialEngineSolutions
 * @license    http://www.socialenginesolutions.com/license/
 * @version    $Id: Pages.php  2018-11-24 00:00:00 SocialEngineSolutions $
 * @author     SocialEngineSolutions
 */
class Sespwa_Model_DbTable_Pages extends Engine_Db_Table implements Engine_Content_Storage_Interface
{
  protected $_rowClass = 'Sespwa_Model_Page';

  public function loadMetaData(Engine_Content $contentAdapter, $name)
  {
    $select = $this->select()->where('name = ?', $name)->orWhere('page_id = ?', $name);
    $page = $this->fetchRow($select);

    if( !is_object($page) ) {
      // throw?
      return null;
    }

    return $page->toArray();
  }

  public function loadContent(Engine_Content $contentAdapter, $name)
  {
    if( is_array($name) ) {
      $name = join('_', $name);
    }
    if( !is_string($name) && !is_numeric($name) ) {
      throw new Exception('not string');
    }

    $select = $this->select()->where('name = ?', $name)->orWhere('page_id = ?', $name);
    $page = $this->fetchRow($select);

    if( !is_object($page) ) {
      // throw?
      return null;
    }

    // Get all content
    $contentTable = Engine_Api::_()->getDbtable('content', 'sespwa');
    $select = $contentTable->select()
      ->where('page_id = ?', $page->page_id)
      ->order('order ASC');

    //Show left right column work
    if(empty(Engine_Api::_()->getApi('settings', 'core')->getSetting('sespwa.showleftright', 0))) {
        $select = $select->where('name <> ?', 'left')
                        ->where('name <> ?', 'right');
    }

    $content = $contentTable->fetchAll($select);

    // Create structure
    $structure = $this->prepareContentArea($content);

    // Create element (with structure)
    $element = new Engine_Content_Element_Container(array(
      'class' => 'layout_page_' . $page->name,
      'elements' => $structure
    ));

    return $element;
  }

  public function prepareContentArea($content, $current = null)
  {
    // Get parent content id
    $parent_content_id = null;
    if( null !== $current ) {
      $parent_content_id = $current->content_id;
    }

    // Get children
    $children = $content->getRowsMatching('parent_content_id', $parent_content_id);
    if( empty($children) && null === $parent_content_id ) {
      $children = $content->getRowsMatching('parent_content_id', 0);
    }

    // Get struct
    $struct = array();
    foreach( $children as $child ) {
      $elStruct = $this->createElementParams($child);
      if( $elStruct ) {
        $elStruct['elements'] = $this->prepareContentArea($content, $child);
        $struct[] = $elStruct;
      }
    }

    return $struct;
  }

  public function createElementParams($row)
  {
    $data = array(
      'identity' => $row->content_id,
      'type' => $row->type,
      'name' => $row->name,
      'order' => $row->order,
    );
    $params = (array) $row->params;
    if( isset($params['title']) ) {
      $data['title'] = $params['title'];
    }
    $data['params'] = $params;

    // Check mobile here?
    if( !empty($params['nomobile']) &&
        Engine_Api::_()->hasModuleBootstrap('mobi') &&
        !empty($_SESSION['mobile']) &&
        !empty($_SESSION['mobile']['mobile']) ) {
      return false;
    }

    return $data;
  }

  public function deletePage(Sespwa_Model_Page $page)
  {
    $contentTable = Engine_Api::_()->getDbtable('content', 'sespwa');
    $contentTable->delete(array(
      'page_id = ?' => $page->page_id,
    ));

    $page->delete();

    return $this;
  }
}
