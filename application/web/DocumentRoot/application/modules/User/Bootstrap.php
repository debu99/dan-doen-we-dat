<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: Bootstrap.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 */
class User_Bootstrap extends Engine_Application_Bootstrap_Abstract
{
  public function __construct($application)
  {
    parent::__construct($application);
    
    // Add view helper and action helper paths
    $this->initViewHelperPath();
    $this->initActionHelperPath();

    // Add main user javascript
    //$headScript = new Zend_View_Helper_HeadScript();
    //$headScript->appendFile('application/modules/User/externals/scripts/core.js');

    // Get viewer
    $viewer = Engine_Api::_()->user()->getViewer();

    // Check if they were disabled
    if( $viewer->getIdentity() && !$viewer->enabled ) {
      Engine_Api::_()->user()->getAuth()->clearIdentity();
      Engine_Api::_()->user()->setViewer(null);
    }

    // Check user online state
    $table = Engine_Api::_()->getDbtable('online', 'user');
    $table->check($viewer);

      $front = Zend_Controller_Front::getInstance();
      $front->registerPlugin(new User_Plugin_Core);
  }
}
