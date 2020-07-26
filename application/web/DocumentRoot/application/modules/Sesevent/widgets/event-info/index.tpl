<?php
/**
 * SocialEngineSolutions
 *
 * @category   Application_Sesevent
 * @package    Sesevent
 * @copyright  Copyright 2015-2016 SocialEngineSolutions
 * @license    http://www.socialenginesolutions.com/license/
 * @version    $Id: index.tpl 2016-07-26 00:00:00 SocialEngineSolutions $
 * @author     SocialEngineSolutions
 */
?>
<div class='sesevent_profile_info sesbasic_clearfix sesbasic_bxs'>
  <div class="sesevent_profile_info_row">
    <div class="sesevent_profile_info_head"><?php echo $this->translate("Basic Info"); ?></div>
    <ul class="sesevent_profile_info_row_info">
      <li class="sesbasic_clearfix">
        <span><?php echo $this->translate("Created by"); ?></span>
        <span><a href="<?php echo $this->subject->getOwner()->getHref(); ?>"><?php echo $this->subject->getOwner()->getTitle(); ?></a></span>
      </li>
      <?php $host = Engine_Api::_()->getItem('sesevent_host', $this->subject->host);; ?>
      <li class="sesbasic_clearfix">
        <span><?php echo $this->translate("Hosted by"); ?></span>
        <span><a href="<?php echo $host->getHref(); ?>"><?php echo $host->getTitle(); ?></a></span>
      </li>
      <li class="sesbasic_clearfix">
        <span><?php echo $this->translate("Created on"); ?></span>
        <span><?php echo $this->translate('%1$s', $this->timestamp($this->subject->creation_date)); ?></span>
      </li>
      <li class="sesbasic_clearfix">
        <span><?php echo $this->translate("Stats"); ?></span>
        <span>
          <span><?php echo $this->translate(array('<b>%s</b> Like', '<b>%s</b> Likes', $this->subject->like_count), $this->locale()->toNumber($this->subject->like_count)) ?>, </span>
          <span><?php echo $this->translate(array('<b>%s</b> Comment', '<b>%s</b> Comments', $this->subject->comment_count), $this->locale()->toNumber($this->subject->comment_count)) ?>, </span>
          <span><?php echo $this->translate(array('<b>%s</b> View', '<b>%s</b> Views', $this->subject->view_count), $this->locale()->toNumber($this->subject->view_count)) ?>, </span>
          <span><?php echo $this->translate(array('<b>%s</b> Favourite', '<b>%s</b> Favourites', $this->subject->favourite_count), $this->locale()->toNumber($this->subject->favourite_count)) ?></span>
        </span>
      </li>
    </ul>
  </div>
  <div class="sesevent_profile_info_row">
    <div class="sesevent_profile_info_head"><?php echo $this->translate("When & Where"); ?></div>
    <ul class="sesevent_profile_info_row_info">
      <li class="sesbasic_clearfix">
        <span><?php echo $this->translate("When"); ?></span>
        <span><?php echo $this->eventStartEndDates($this->subject); ?></span>
      </li>
     <?php if(Engine_Api::_()->getApi('settings', 'core')->getSetting('sesevent_enable_location', 1)){ ?>
      <li class="sesbasic_clearfix">
        <span><?php echo $this->translate("Where"); ?></span>
        <span> <a href='<?php echo $this->url(array('resource_id' => $this->subject->event_id,'resource_type'=>'sesevent_event','action'=>'get-direction'), 'sesbasic_get_direction', true); ?>' class="openSmoothbox"><?php echo $this->subject->location; ?> </a> </span>
      </li>
      <?php } ?>
    </ul>
  </div>
  <div class="sesevent_profile_info_row">
    <div class="sesevent_profile_info_head"><?php echo $this->translate("Meta Info"); ?></div>
    <ul class="sesevent_profile_info_row_info">
      <?php if($this->subject->category_id){ ?>
      <?php $category = Engine_Api::_()->getItem('sesevent_category',$this->subject->category_id); ?>
       <?php if($category){ ?>
        <li class="sesbasic_clearfix">
          <span><?php echo $this->translate("Category"); ?></span>
          <span><a href="<?php echo $category->getHref(); ?>"><?php echo $category->category_name; ?></a>
          	<?php $subcategory = Engine_Api::_()->getItem('sesevent_category',$this->subject->subcat_id); ?>
             <?php if($subcategory && $this->subject->subcat_id != 0){ ?>
                &nbsp;&raquo;&nbsp;<a href="<?php echo $subcategory->getHref(); ?>"><?php echo $subcategory->category_name; ?></a>
            <?php $subsubcategory = Engine_Api::_()->getItem('sesevent_category',$this->subject->subsubcat_id); ?>
             <?php if($subsubcategory && $this->subject->subsubcat_id != 0){ ?>
                &nbsp;&raquo;&nbsp;<a href="<?php echo $subsubcategory->getHref(); ?>"><?php echo $subsubcategory->category_name; ?></a>
            <?php } ?>
          <?php } ?></span>
        </li>
        <?php }          
      } ?>
      <?php if(count($this->eventTags)){ ?>
        <li class="sesbasic_clearfix">
          <span><?php echo $this->translate("Tags"); ?></span>
          <span>
            <?php 
            	$counter = 1;
            	 foreach($this->eventTags as $tag):
                if($tag->getTag()->text != ''){ ?>
                  <a href='javascript:void(0);' onclick='javascript:tagAction(<?php echo $tag->getTag()->tag_id; ?>,"<?php echo $tag->getTag()->text; ?>");'>#<?php echo $tag->getTag()->text ?></a>
                  <?php if(count($this->eventTags) != $counter){ 
                  	echo ",";	
                   } ?>
          <?php	 } 
          		$counter++;
              endforeach;  ?>
          </span>
        </li>
      <?php } ?>
    </ul>
  </div>
  <?php if( !empty($this->subject->description) ): ?>
  <div class="sesevent_profile_info_row">
      <div class="sesevent_profile_info_head"><?php echo $this->translate("Details"); ?></div>
      <ul class="sesevent_profile_info_row_info">
        <li class="sesbasic_clearfix"><?php echo nl2br($this->subject->description) ?></li>
      </ul>
    </div>
  <?php endif ?>
  <div class="sesevent_profile_info_row" id="sesevent_custom_fields_val">
    <div class="sesevent_profile_info_head"><?php echo $this->translate("Other Info"); ?></div>
    <div class="sesevent_view_custom_fields">
      <?php
        //custom field data
        echo $this->sesbasicFieldValueLoop($this->subject);
      ?>
    </div>
  </div>
</div> 
<script type="application/javascript">
sesJqueryObject(document).ready(function(e){
	//var lengthCustomFi	= sesJqueryObject('#sesevent_profile_info_row_info').children().length;
	if(!sesJqueryObject('.sesevent_view_custom_fields').html().trim()){
		sesJqueryObject('#sesevent_custom_fields_val').hide();
	}
})
var tabId_info = <?php echo $this->identity; ?>;
window.addEvent('domready', function() {
	tabContainerHrefSesbasic(tabId_info);	
});
var tagAction = window.tagAction = function(tag,value){
	var url = "<?php echo $this->url(array('module' => 'sesevent','action'=>'browse'), 'sesevent_general', true) ?>?tag_id="+tag+'&tag_name='+value;
 window.location.href = url;
}
</script>