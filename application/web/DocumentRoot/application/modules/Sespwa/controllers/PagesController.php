<?php

/**
 * SocialEngineSolutions
 *
 * @category   Application_Sespwa
 * @package    Sespwa
 * @copyright  Copyright 2018-2019 SocialEngineSolutions
 * @license    http://www.socialenginesolutions.com/license/
 * @version    $Id: PagesController.php  2018-11-24 00:00:00 SocialEngineSolutions $
 * @author     SocialEngineSolutions
 */
 
class Sespwa_PagesController extends Core_Controller_Action_Standard
{
  public function __call($methodName, $args)
  {
    // Not an action
    if( 'Action' != substr($methodName, -6) ) {
      throw new Zend_Controller_Action_Exception(sprintf('Method "%s" does not exist and was not trapped in __call()', $methodName), 500);
    }

    // Get page
    $action = $this->_getParam('action');
    if (!$action) {
      $action = substr($methodName, 0, strlen($methodName) - 6);
      $actionNormal = strtolower(preg_replace('/([A-Z])/', '-\1', $action));
    } else {
      $actionNormal = $action;
    }

    // Get page object
    $pageTable = Engine_Api::_()->getDbtable('pages', 'sespwa');
    $pageSelect = $pageTable->select();

    if( is_numeric($actionNormal) ) {
      $pageSelect->where('page_id = ?', $actionNormal);
    } else {
      $pageSelect
        ->orWhere('name = ?', str_replace('-', '_', $actionNormal))
        ->orWhere('url = ?', str_replace('_', '-', $actionNormal));
    }

    $pageObject = $pageTable->fetchRow($pageSelect);

    // Page found
    if( null !== $pageObject ) {
      // Check if the viewer can view this page
      $viewer = Engine_Api::_()->user()->getViewer();
      if( $pageObject->custom && !$pageObject->allowedToView($viewer) ) {
        return $this->_forward('requireauth', 'error', 'core');
      }
      // Render the page
      $this->_helper->content
        ->setContentName($pageObject->page_id)
        ->setNoRender()
        ->setEnabled();
      return;
    }


    // Missing page
    throw new Zend_Controller_Action_Exception(sprintf('Action "%s" does not exist and was not trapped in __call()', $action), 404);
  }
}
