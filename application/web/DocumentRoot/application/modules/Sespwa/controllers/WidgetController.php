<?php
/**
 * SocialEngine
 *
 * @category   Application_Sespwa
 * @package    Sespwa
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: WidgetController.php 10132 2014-02-10 17:06:01Z andres $
 * @author     John
 */

/**
 * @category   Application_Sespwa
 * @package    Sespwa
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 */
class Sespwa_WidgetController extends Core_Controller_Action_Standard
{
  public function indexAction()
  {
    $content_id = $this->_getParam('content_id');
    $view = $this->_getParam('view');
    $show_container = $this->_getParam('container', true);
    $params = $this->_getAllParams();

    // Render by content row
    if( null !== $content_id ) {
      $contentTable = Engine_Api::_()->getDbtable('content', 'sespwa');
      $row = $contentTable->find($content_id)->current();
      if( null !== $row ) {
        // Build full structure from children
        $page_id = $row->page_id;
        $pageTable = Engine_Api::_()->getDbtable('pages', 'sespwa');
        $content = $contentTable->fetchAll($contentTable->select()->where('page_id = ?', $page_id));
        $structure = $pageTable->createElementParams($row);
        $children = $pageTable->prepareContentArea($content, $row);
        if( !empty($children) ) {
          $structure['elements'] = $children;
        }
        $structure['request'] = $this->getRequest();
        $structure['action'] = $view;

        // Create element (with structure)
        $element = new Engine_Content_Element_Container(array(
          'elements' => array($structure),
          'decorators' => array(
            'Children'
          )
        ));

        // Strip decorators
        if( !$show_container ) {
          foreach( $element->getElements() as $cel ) {
            $cel->clearDecorators();
          }
        }

        $content = $element->render();
        $this->getResponse()->setBody($content);
      }

      $this->_helper->viewRenderer->setNoRender(true);
      return;
    }

    // Render by widget name
    $mod = $this->_getParam('mod');
    $name = $this->_getParam('name');
    if( null !== $name ) {
      if( null !== $mod ) {
        $name = $mod . '.' . $name;
      }
      $structure = array(
        'type' => 'widget',
        'name' => $name,
        'request' => $this->getRequest(),
        'action' => $view,
      );

      // Create element (with structure)
      $element = new Engine_Content_Element_Container(array(
        'elements' => array($structure),
        'decorators' => array(
          'Children'
        )
      ));

      $content = $element->render();
      $this->getResponse()->setBody($content);

      $this->_helper->viewRenderer->setNoRender(true);
      return;
    }

    $this->getResponse()
        ->setRawHeader($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found')
        ->setBody('Aw, shucks.');
    $this->_helper->viewRenderer->setNoRender(true);

    return;
  }
}
