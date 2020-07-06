<?php
/**
 * SocialEngine
 *
 * @category   Application_Core
 * @package    Core
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: index.tpl 9905 2013-02-14 02:46:28Z alex $
 * @author     John
 */
?>
<div>
  <div class="admin_manage_listings"><input type="checkbox" id="storelisting" onclick="showHide(1)" <?php if(Engine_Api::_()->getApi('settings', 'core')->getSetting('core.storelisting')) { ?> checked <?php } ?>> <?php echo $this->translate("Show Store Listings"); ?></div>
  <div class="admin_manage_news"><input type="checkbox" id="newsupdates" onclick="showHide(2)" <?php if(Engine_Api::_()->getApi('settings', 'core')->getSetting('core.newsupdates')) { ?> checked <?php } ?>> <?php echo $this->translate("Show News & Updates"); ?></div>
</div>
<script>
  function showHide(value) {
    if(value == 1) {
      var checkBox = document.getElementById("storelisting");
    } else {
      var checkBox = document.getElementById("newsupdates");
    }
    (new Request.JSON({
      method: 'post',
      'url': en4.core.baseUrl + 'core/index/showadmincontent/',
      'data': {
        format: 'json',
        showcontent: checkBox.checked,
        value: value,
      },
      onSuccess: function(responseTree, responseElements, responseHTML, responseJavaScript) {
        location.reload();
      }
    })).send();
    return false;
  }
</script>
