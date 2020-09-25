<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: User.php 9747 2012-07-26 02:08:08Z john $
 * @author     John
 */

/**
 * @category   Application_Core
 * @package    User
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 */
class User_Model_User extends Core_Model_Item_Abstract
{
  protected $_searchTriggers = array('search', 'displayname', 'username');
  /**
   * Gets the title of the user (their username)
   *
   * @return string
   */
  public function getTitle()
  {

    $showLastName = $this->showLastName();
    $fieldValues = Engine_Api::_()->fields()->getFieldsValuesByAlias($this);

    if($showLastName && isset($this->displayname) && '' !== trim($this->displayname) ) {
      return $this->displayname;
    } else if(!$showLastName && isset($fieldValues['first_name']) && '' !== trim($fieldValues['first_name'])){
      return $fieldValues['first_name'];
    }
    else if( isset($this->username) && '' !== trim($this->username) ) {
      return $this->username;
    } else if( isset($this->email) && '' !== trim($this->email) ) {
      $tmp = explode('@', $this->email);
      return $tmp[0];
    } else {
      return "<i>" . Zend_Registry::get('Zend_Translate')->_("Deleted Member") . "</i>";
    }
  }

  public function showLastName(){
      $partialStructure = Engine_Api::_()->sesbasic()->getFieldsStructurePartial($this);
      $subject = Engine_Api::_()->user()->getViewer();

      // // Evaluate privacy
      // $relationship = 'everyone';
      // if( $this->getIdentity() == $subject->getIdentity() ) {
      //   $relationship = 'self';
      //   return true;
      // } elseif( $this->membership()->isMember($subject, true) ) {
      //   $relationship = 'friends';
      //   return true;
      // } 

      foreach( $partialStructure as $map ) {

        $field = $map->getChild();
        $value = $field->getValue($subject);

        if($field['type'] === "last_name") {
          return $field->display;;
        }
      }
  }
  /**
   * Gets an absolute URL to the page to view this item
   *
   * @return string
   */
  public function getHref($params = array())
  {
    $profileAddress = null;
    if( isset($this->username) && '' != trim($this->username) ) {
      $profileAddress = $this->username;
    } else if( isset($this->user_id) && $this->user_id > 0 ) {
      $profileAddress = $this->user_id;
    } else {
      return 'javascript:void(0);';
    }
    
    $params = array_merge(array(
      'route' => 'user_profile',
      'reset' => true,
      'id' => $profileAddress,
    ), $params);
    $route = $params['route'];
    $reset = $params['reset'];
    unset($params['route']);
    unset($params['reset']);
    return Zend_Controller_Front::getInstance()->getRouter()
      ->assemble($params, $route, $reset);
  }


  public function setDisplayName($displayName)
  {
    if( is_string($displayName) )
    {
      $this->displayname = $displayName;
    }

    else if( is_array($displayName) )
    {
      // Has both names
      if( !empty($displayName['first_name']) && !empty($displayName['last_name']) )
      {
        $displayName = $displayName['first_name'].' '.$displayName['last_name'];
      }
      // Has full name
      else if( !empty($displayName['full_name']) )
      {
        $displayName = $displayName['full_name'];
      }
      // Has only first
      else if( !empty($displayName['first_name']) )
      {
        $displayName = $displayName['first_name'];
      }
      // Has only last
      else if( !empty($displayName['last_name']) )
      {
        $displayName = $displayName['last_name'];
      }
      // Has neither (use username)
      else
      {
        $displayName = $this->username;
      }
      
      $this->displayname = $displayName;
    }
  }

  public function setPhoto($photo)
  {
    if( $photo instanceof Zend_Form_Element_File ) {
      $file = $photo->getFileName();
      $fileName = $file;
    } else if( $photo instanceof Storage_Model_File ) {
      $file = $photo->temporary();
      $fileName = $photo->name;
    } else if( $photo instanceof Core_Model_Item_Abstract && !empty($photo->file_id) ) {
      $tmpRow = Engine_Api::_()->getItem('storage_file', $photo->file_id);
      $file = $tmpRow->temporary();
      $fileName = $tmpRow->name;
    } else if( is_array($photo) && !empty($photo['tmp_name']) ) {
      $file = $photo['tmp_name'];
      $fileName = $photo['name'];
    } else if( is_string($photo) && file_exists($photo) ) {
      $file = $photo;
      $fileName = $photo;
    } else {
      throw new User_Model_Exception('invalid argument passed to setPhoto');
    }

    if( !$fileName ) {
      $fileName = $file;
    }

    $name = basename($file);
    $extension = ltrim(strrchr(basename($fileName), '.'), '.');
    $base = rtrim(substr(basename($fileName), 0, strrpos(basename($fileName), '.')), '.');
    $path = APPLICATION_PATH . DIRECTORY_SEPARATOR . 'temporary';
    $params = array(
      'parent_type' => $this->getType(),
      'parent_id' => $this->getIdentity(),
      'user_id' => $this->getIdentity(),
      'name' => basename($fileName),
    );

    // Save
    $filesTable = Engine_Api::_()->getDbtable('files', 'storage');

    // Resize image (main)
    $mainPath = $path . DIRECTORY_SEPARATOR . $base . '_m.' . $extension;
    $image = Engine_Image::factory();
    $image->open($file)
      ->autoRotate()
      ->resize(720, 720)
      ->write($mainPath)
      ->destroy();

    // Resize image (profile)
    $profilePath = $path . DIRECTORY_SEPARATOR . $base . '_p.' . $extension;
    $image = Engine_Image::factory();
    $image->open($file)
      ->autoRotate()
      ->resize(320, 640)
      ->write($profilePath)
      ->destroy();

    // Resize image (normal)
    $normalPath = $path . DIRECTORY_SEPARATOR . $base . '_in.' . $extension;
    $image = Engine_Image::factory();
    $image->open($file)
      ->autoRotate()
      ->resize(140, 160)
      ->write($normalPath)
      ->destroy();

    // Resize image (icon)
    $squarePath = $path . DIRECTORY_SEPARATOR . $base . '_is.' . $extension;
    $image = Engine_Image::factory();
    $image->open($file)
      ->autoRotate();

    $size = min($image->height, $image->width);
    $x = ($image->width - $size) / 2;
    $y = ($image->height - $size) / 2;

    $image->resample($x, $y, $size, $size, 48, 48)
      ->write($squarePath)
      ->destroy();

    // Store
    $iMain = $filesTable->createFile($mainPath, $params);
    $iProfile = $filesTable->createFile($profilePath, $params);
    $iIconNormal = $filesTable->createFile($normalPath, $params);
    $iSquare = $filesTable->createFile($squarePath, $params);

    $iMain->bridge($iProfile, 'thumb.profile');
    $iMain->bridge($iIconNormal, 'thumb.normal');
    $iMain->bridge($iSquare, 'thumb.icon');

    // Remove temp files
    @unlink($mainPath);
    @unlink($profilePath);
    @unlink($normalPath);
    @unlink($squarePath);

    // Update row
    $this->modified_date = date('Y-m-d H:i:s');
    $this->photo_id = $iMain->file_id;
    $this->save();

    return $this;
  }

  public function isAllowed($resource, $action = 'view')
  {
    return Engine_Api::_()->getApi('core', 'authorization')->isAllowed($resource, $this, $action);
  }

  public function isEnabled()
  {
    return ( $this->enabled );
  }

  public function isAdmin()
  {
    // Not logged in, not an admin
    if( !$this->getIdentity() || empty($this->level_id) ) {
      return false;
    }
    
    // Check level
    //return (bool) Engine_Registry::get('database-default')
    // return (bool) Zend_Registry::get('Zend_Db')
    return $this->getTable()->getAdapter()
        ->select()
        ->from('engine4_authorization_levels', new Zend_Db_Expr('TRUE'))
        ->where('level_id = ?', $this->level_id)
        ->where('type IN(?)', array('admin', 'moderator'))
        ->limit(1)
        ->query()
        ->fetchColumn();
  }
  
  public function isAdminOnly()
  {
    // Not logged in, not an admin
    if( !$this->getIdentity() || empty($this->level_id) ) {
      return false;
    }
    
    // Check level
    //return (bool) Engine_Registry::get('database-default')
    // return (bool) Zend_Registry::get('Zend_Db')
    return $this->getTable()->getAdapter()
        ->select()
        ->from('engine4_authorization_levels', new Zend_Db_Expr('TRUE'))
        ->where('level_id = ?', $this->level_id)
        ->where('type IN(?)', array('admin'))
        ->limit(1)
        ->query()
        ->fetchColumn();
  }

  // Internal hooks

  protected function _insert()
  {
    $settings = Engine_Api::_()->getApi('settings', 'core');
    $mappedLevel = 0;
    $accountSession = new Zend_Session_Namespace('User_Plugin_Signup_Account');
    $profileTypeValue = @$accountSession->data['profile_type'];
    $mappedLevel = Engine_Api::_()->getDbtable('mapProfileTypeLevels', 'authorization')->getMappedLevelId($profileTypeValue);
    // These need to be done first so the hook can see them
    $this->level_id = $mappedLevel ? $mappedLevel :
      Engine_Api::_()->getItemTable('authorization_level')->getDefaultLevel()->level_id;
    $this->approved = (int) ($settings->getSetting('user.signup.approve', 1) == 1);
    $this->verified = (int) ($settings->getSetting('user.signup.verifyemail', 1) < 2);
    $this->enabled  = ( $this->approved && $this->verified );
    $this->search   = true;

    if( empty($this->_modifiedFields['timezone']) ) {
      $this->timezone = $settings->getSetting('core.locale.timezone', 'America/Los_Angeles');
    }
    if( empty($this->_modifiedFields['locale']) ) {
      $this->locale = $settings->getSetting('core.locale.locale', 'auto');
    }
    if( empty($this->_modifiedFields['language']) ) {
      $this->language = $settings->getSetting('core.locale.language', 'en_US');
    }
    
    if( 'cli' !== PHP_SAPI ) { // No CLI
      // Get ip address
      $db = $this->getTable()->getAdapter();
      $ipObj = new Engine_IP();
      $ipExpr = new Zend_Db_Expr($db->quoteInto('UNHEX(?)', bin2hex($ipObj->toBinary())));
      $this->creation_ip = $ipExpr;
    }

    // Set defaults, process etc
    $this->salt = (string) rand(1000000, 9999999);
    if( !empty($this->password) ) {
//      $this->password = md5( $settings->getSetting('core.secret', 'staticSalt')
//                          . $this->password
//                          . $this->salt );
        $this->password = password_hash($this->password, PASSWORD_DEFAULT);
    } else {
      $this->password = '';
    }

    // The hook will be called here
    parent::_insert();
  }

  protected function _postInsert()
  {
    parent::_postInsert();
    
    // Create auth stuff
    $context = Engine_Api::_()->authorization()->context;
    
    // View
    $view_options = (array) Engine_Api::_()->authorization()->getAdapter('levels')->getAllowed('user', $this, 'auth_view');
    if( empty($view_options) || !is_array($view_options) ) {
      $view_options = array('member', 'network', 'registered', 'everyone');
    }
    foreach( $view_options as $role ) {
      $context->setAllowed($this, $role, 'view', true);
    }

    // update 'view_privacy'
    $viewPrivacy = 'owner';
    if( in_array('everyone', $view_options) ) {
      $viewPrivacy = 'everyone';
    } elseif( in_array('registered', $view_options) ) {
      $viewPrivacy = 'registered';
    } elseif( in_array('network', $view_options) ) {
      $viewPrivacy = 'network';
    } elseif( in_array('member', $view_options) ) {
      $viewPrivacy = 'member';
    }

    $table = Engine_Api::_()->getDbtable('users', 'user');
    $where = $table->getAdapter()->quoteInto('user_id = ?', $this->user_id);
    $table->update(array('view_privacy' => $viewPrivacy), $where);

    // Comment
    $comment_options = (array) Engine_Api::_()->authorization()->getAdapter('levels')->getAllowed('user', $this, 'auth_comment');
    if( empty($comment_options) || !is_array($comment_options) ) {
      $comment_options = array('member', 'network', 'registered', 'everyone');
    }
    foreach( $comment_options as $role ) {
      $context->setAllowed($this, $role, 'comment', true);
    }
  }

  protected function _update()
  {
    $settings = Engine_Api::_()->getApi('settings', 'core');
    
    // Hash password if being updated
    if( !empty($this->_modifiedFields['password']) ) {
      if( empty($this->salt) ) {
        $this->salt = (string) rand(1000000, 9999999);
      }
      $this->password = password_hash($this->password,PASSWORD_DEFAULT);
//      $this->password = md5( $settings->getSetting('core.secret', 'staticSalt')
//        . $this->password
//        . $this->salt );
    }

    // Update enabled, hook will set to false if necessary
    if( !empty($this->_modifiedFields['approved']) ||
        !empty($this->_modifiedFields['verified']) ||
        !empty($this->_modifiedFields['enabled']) ) {
      $enabled = true;
      if( $this->_cleanData['enabled'] != $this->enabled ) {
        $enabled = $this->enabled;
      }
      if( 2 === (int) $settings->getSetting('user.signup.verifyemail', 0) ) {
        $this->enabled = ( $this->approved && $this->verified && $enabled );
      } else {
        $this->enabled = (bool) $this->approved && $enabled;
      }
    }

    // Call parent
    parent::_update();
  }

  protected function _delete()
  {
    // Check level
    $level = Engine_Api::_()->getItem('authorization_level', $this->level_id);
    if( $level->flag == 'superadmin' ) {
      throw new User_Model_Exception('Cannot delete superadmins.');
    }
    
    // Remove from online users
    $table = Engine_Api::_()->getDbtable('online', 'user');
    $table->delete(array('user_id = ?' => $this->getIdentity()));

    // Remove from verify users
    $verifyTable = Engine_Api::_()->getDbtable('verify', 'user');
    $verifyTable->delete(array('user_id = ?' => $this->getIdentity()));
    
    // Remove fields values
    Engine_Api::_()->fields()->removeItemValues($this);

    // Call parent
    parent::_delete();
  }



  // Ownership

  public function isOwner($owner)
  {
    // A user only can be owned by self
    return ( $owner->getGuid(false) === $this->getGuid(false) );
  }

  public function getOwner($recurseType = null)
  {
    // A user only can be owned by self
    return $this;
  }

  public function getParent($recurseType = null)
  {
    // A user can only belong to self
    return $this;
  }



  // Blocking
  
  public function isBlocked($user)
  {
    // Check auth?
    if( !Engine_Api::_()->authorization()->isAllowed('user', $user, 'block') ) {
      return false;
    }

    $table = Engine_Api::_()->getDbtable('block', 'user');
    $select = $table->select()
      ->where('user_id = ?', $this->getIdentity())
      ->where('blocked_user_id = ?', $user->getIdentity())
      ->limit(1);
    $row = $table->fetchRow($select);
    return ( null !== $row );
  }

  public function isBlockedBy($user)
  {
    // Check auth?
    if( !Engine_Api::_()->authorization()->isAllowed('user', $user, 'block') ) {
      return false;
    }
    
    $table = Engine_Api::_()->getDbtable('block', 'user');
    $select = $table->select()
      ->where('user_id = ?', $user->getIdentity())
      ->where('blocked_user_id = ?', $this->getIdentity())
      ->limit(1);
    $row = $table->fetchRow($select);
    return ( null !== $row );
  }

  public function getBlockedUsers()
  {
    $user = Engine_Api::_()->user()->getViewer();
    // Check auth?
    if( !Engine_Api::_()->authorization()->isAllowed('user', $user, 'block') ) {
      return array();
    }
    
    $table = Engine_Api::_()->getDbtable('block', 'user');
    $select = $table->select()
      ->where('user_id = ?', $this->getIdentity());
    
    $ids = array();
    foreach( $table->fetchAll($select) as $row )
    {
      $ids[] = $row->blocked_user_id;
    }

    return $ids;
  }

  public function getBlockedUserIds()
  {
    if( !Engine_Api::_()->authorization()->isAllowed('user', null, 'block') ) {
      return array();
    }

    $table = Engine_Api::_()->getDbtable('block', 'user');
    $select = $table->select()
      ->where('blocked_user_id = ?', $this->getIdentity());

    $ids = array();
    foreach( $table->fetchAll($select) as $row ) {
      $ids[] = $row->user_id;
    }

    return $ids;
  }

  public function getAllBlockedUserIds()
  {
    return array_unique(array_merge($this->getBlockedUsers(), $this->getBlockedUserIds()));
  }

  public function addBlock(User_Model_User $user)
  {
    // Check auth?
    //die(Engine_Api::_()->authorization()->isAllowed($user, $this, 'block'));
    if( !Engine_Api::_()->authorization()->isAllowed('user', $user, 'block') ) {
      return $this;
    }
    
    if( !$this->isBlocked($user) && $user->getGuid(false) != $this->getGuid(false) )
    {
      $db = Engine_Db_Table::getDefaultAdapter();
      $db->beginTransaction();
      try
      {
        Engine_Api::_()->getDbtable('block', 'user')
          ->insert(array(
            'user_id' => $this->getIdentity(),
            'blocked_user_id' => $user->getIdentity()
          ));
      }
      catch( Exception $e )
      {
        $db->rollBack();
        throw $e;
      }
    }

    return $this;
  }

  public function removeBlock(User_Model_User $user)
  {
    // Check auth?
    if( !Engine_Api::_()->authorization()->isAllowed('user', $user, 'block') ) {
      return $this;
    }
    
    Engine_Api::_()->getDbtable('block', 'user')
      ->delete(array(
        'user_id = ?' => $this->getIdentity(),
        'blocked_user_id = ?' => $user->getIdentity()
      ));
      
    return $this;
  }



  // Interfaces

  /**
   * Gets a proxy object for the likes handler
   *
   * @return Engine_ProxyObject
   **/
  public function likes()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('likes', 'core'));
  }

  /**
   * Gets a proxy object for the comment handler
   *
   * @return Engine_ProxyObject
   **/
  public function comments()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('comments', 'core'));
  }

  /**
   * Gets a proxy object for the fields handler
   *
   * @return Engine_ProxyObject
   */
  public function fields()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getApi('core', 'fields'));
  }

  /**
   * Gets a proxy object for the membership handler
   * 
   * @return Engine_ProxyObject
   */
  public function membership()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('membership', 'user'));
  }

  public function lists()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('lists', 'user'));
  }


  /**
   * Gets a proxy object for the fields handler
   *
   * @return Engine_ProxyObject
   */
  public function status()
  {
    return new Engine_ProxyObject($this, Engine_Api::_()->getDbtable('status', 'core'));
  }



  // Utility
  
  protected function _readData($spec)
  {
    if( is_scalar($spec) )
    {
      // Identity
      if( is_numeric($spec) )
      {
        // Can't use find because it won't return a row class
        $spec = $this->getTable()->fetchRow($this->getTable()->select()->where("user_id = ?", $spec));
      }

      // By email
      else if( is_string($spec) && strpos($spec, '@') !== false )
      {
        $spec = $this->getTable()->fetchRow($this->getTable()->select()->where("email = ?", $spec));
      }

      // By username
      else if( is_string($spec) )
      {
        $spec = $this->getTable()->fetchRow($this->getTable()->select()->where("username = ?", $spec));
      }
    }

    parent::_readData($spec);
  }

  public function getBirthdate(){
    
      $db = Engine_Db_Table::getDefaultAdapter();

      $birthDate = $db->select()
                  ->from('engine4_user_fields_meta')
                  ->where('type = ?', 'birthdate')
                  ->query()
                  ->fetch(); 
      $birthDateFieldId = $birthDate['field_id'];

      $birthDayUser = $db->select()
            ->from('engine4_user_fields_values')
            ->where('item_id = ?',$this->getIdentity()) // user_id
             ->where('field_id = ?',  $birthDateFieldId) // field_id
            ->query()
            ->fetch();

      return $birthDayUser['value'];
  }
  public function getAge($birthday){
    $first_date = new DateTime($this->getBirthdate());
    $second_date = new DateTime("now");
    $ageInYears = $first_date->diff($second_date)->y;
    return $ageInYears;
  }

  public function getAgeCategory(){
    $ageCategories = array(
      '18'=> '18-28',
      '29'=> '29-39',
      '40'=> '40-50',
      '51'=> '51-61',
      '62'=> '62-72',
      '73'=> '73-88',
    );
    $ageUser = $this->getAge($this->getBirthdate());
    foreach($ageCategories as $key => $value){
      if($ageUser >= (int)$key && 
        ($ageUser <= (int)$key + 10 || ($ageUser >= 73 && $ageUser <= 88))) return $key;
    }
  }

  public function userIsInAgeRange($event){
    $age =  $this->getAge($this->getBirthdate());

    if(!isset($event->age_category_from) || !isset($event->age_category_to)) return true;
    return $age >= $event->age_category_from && $age <= $event->age_category_to;
  }


  public function getGender(){
    
    $db = Engine_Db_Table::getDefaultAdapter();

    $gender = $db->select()
                ->from('engine4_user_fields_meta')
                ->where('type = ?', 'gender')
                ->query()
                ->fetch(); 
    $genderFieldId = $gender['field_id'];

    $genderUser = $db->select()
          ->from('engine4_user_fields_values')
          ->where('item_id = ?',$this->getIdentity()) // user_id
           ->where('field_id = ?',  $genderFieldId) // field_id
          ->query()
          ->fetch();
    
    if($genderUser) {
      $genderMap = $db->select()
      ->from('engine4_user_fields_options')
      ->where('option_id = ?',$genderUser['value']) // user_id
       ->where('field_id = ?',  $genderFieldId) // field_id
      ->query()
      ->fetch();
      
      return array(
          "label"=> $genderMap['label'],
          "option_id"=> $genderUser['value']
      );
    }      
  }
}
