<?php
/**
 * SocialEngineSolutions
 *
 * @category   Application_Sesevent
 * @package    Sesevent
 * @copyright  Copyright 2015-2016 SocialEngineSolutions
 * @license    http://www.socialenginesolutions.com/license/
 * @version    $Id: _sidebarWidgetHostData.tpl 2016-07-26 00:00:00 SocialEngineSolutions $
 * @author     SocialEngineSolutions
 */
?>
<?php $this->headScript()->appendFile($this->layout()->staticBaseUrl . 'application/modules/Sesbasic/externals/scripts/sesJquery.js');
?>
<?php $this->headLink()->appendStylesheet($this->layout()->staticBaseUrl . 'application/modules/Sesevent/externals/styles/styles.css'); ?>

<?php foreach( $this->paginator as $item ): ?>
<?php 
$followCount = Engine_Api::_()->getDbtable('follows', 'sesevent')->getFollowCount(array('host_id' => $item->host_id, 'type' => $item->type));
$hostEventCount = Engine_Api::_()->getDbtable('events', 'sesevent')->getHostEventCounts(array('host_id' => $item->host_id, 'type' => $item->type));
$sitehostredirect = Engine_Api::_()->getApi('settings', 'core')->getSetting('sesevent.sitehostredirect', 1); 
if($sitehostredirect && $item->user_id) {
  $user = Engine_Api::_()->getItem('user', $item->user_id);
  $href = $user->getHref();
} else {
  $href = $item->getHref();
}
?>
<?php if($this->view_type == 'list'): ?>
  <li class="sesbasic_sidebar_list sesbasic_clearfix clear">
    <?php echo $this->htmlLink($item, $this->itemPhoto($item, 'thumb.icon')); ?>
    <div class="sesbasic_sidebar_list_info">
      <?php  //if(isset($this->titleActive)){ ?>
        <div class="sesbasic_sidebar_list_title">
          <?php if(strlen($item->getTitle()) > $this->title_truncation_list){
          $title = mb_substr($item->getTitle(),0,($this->title_truncation_list - 3)).'...';
	          echo $this->htmlLink($href,$title );
          } else { ?>
          <?php echo $this->htmlLink($href,$item->getTitle() ) ?>
          <?php } ?>
        </div>
      <?php //} ?>
      
      <div class="sesevent_list_stats">
			  <?php if(isset($this->hostEventCountActive) && isset($hostEventCount)) { ?>
	        <span title="<?php echo $this->translate(array('%s event host', '%s event hosted', $hostEventCount), $this->locale()->toNumber($hostEventCount))?>"><i class="far fa-calendar-alt sesbasic_text_light"></i><?php echo $hostEventCount; ?></span>
        <?php } ?>
        <?php if(isset($this->followActive) && isset($followCount)) { ?>
	        <span title="<?php echo $this->translate(array('%s follow', '%s followed', $followCount), $this->locale()->toNumber($followCount))?>"><i class="fas fa-users sesbasic_text_light"></i><?php echo $followCount; ?></span>
        <?php } ?>
        <?php if(isset($this->viewActive) && isset($item->view_count)) { ?>
        <span title="<?php echo $this->translate(array('%s view', '%s views', $item->view_count), $this->locale()->toNumber($item->view_count))?>"><i class="fa fa-eye sesbasic_text_light"></i><?php echo $item->view_count; ?></span>
        <?php } ?>
        <?php if(isset($this->favouriteActive) && isset($item->favourite_count)) { ?>
        <span title="<?php echo $this->translate(array('%s favourite', '%s favourites', $item->favourite_count), $this->locale()->toNumber($item->favourite_count))?>"><i class="fa fa-heart sesbasic_text_light"></i><?php echo $item->favourite_count; ?></span>
        <?php } ?>
      </div>
    </div>
  </li>
<?php else: ?>
	<li class="sesevent_host_list sesevent_grid_btns_wrap sesbasic_clearfix <?php if($this->contentInsideOutside == 'in'): ?> sesevent_host_list_in <?php else: ?> sesevent_host_list_out <?php endif; ?> <?php if($this->mouseOver): ?> sesae-i-over <?php endif; ?>" style="width:<?php echo is_numeric($this->width) ? $this->width.'px' : $this->width ?>;">
    <div class="sesevent_host_list_thumb" style="height:<?php echo is_numeric($this->height) ? $this->height.'px' : $this->height ?>;">
      <?php
      $href = $href;
      $imageURL = $item->getPhotoUrl('thumb.main');
      ?>
      <a href="<?php echo $href; ?>" class="sesevent_host_list_thumb_img">
        <span style="background-image:url(<?php echo $imageURL; ?>);"></span>
      </a>
      <a href="<?php echo $href; ?>" class="sesevent_host_list_overlay"></a>
      <?php if(isset($this->featuredLabelActive) || isset($this->sponsoredLabelActive)){ ?>
        <p class="sesevent_labels">
          <?php if(isset($this->featuredLabelActive) && $item->featured){ ?>
          	<span class="sesevent_label_featured"><?php echo $this->translate("FEATURED"); ?></span>
          <?php } ?>
          <?php if(isset($this->sponsoredLabelActive) && $item->sponsored){ ?>
          	<span class="sesevent_label_sponsored"><?php echo $this->translate("SPONSORED"); ?></span>
          <?php } ?>
        </p>
				<?php if(isset($this->verifiedLabelActive) && $item->verified){ ?>
        	<div class="sesevent_verified_label" title="<?php echo $this->translate("VERIFIED"); ?>"><i class="fa fa-check"></i></div>
        <?php } ?>
      <?php } ?>
      <?php if(isset($this->socialSharingActive) || isset($this->favouriteButtonActive)) {
      $urlencode = urlencode(((!empty($_SERVER["HTTPS"]) &&  strtolower($_SERVER["HTTPS"]) == 'on') ? "https://" : "http://") . $_SERVER['HTTP_HOST'] . $href); ?>
        <div class="sesevent_grid_btns"> 
          <?php if(isset($this->socialSharingActive)){ ?>
          
          <?php  echo $this->partial('_socialShareIcons.tpl','sesbasic',array('resource' => $item, 'socialshare_enable_plusicon' => $this->socialshare_enable_plusicon, 'socialshare_icon_limit' => $this->socialshare_icon_limit)); ?>

          <?php } 
          $itemtype = 'sesevent_host';
          $getId = 'host_id';
          ?>
          <?php
						if(isset($this->favouriteButtonActive) && isset($item->favourite_count)) {
							$favStatus = Engine_Api::_()->getDbtable('favourites', 'sesevent')->isFavourite(array('resource_type'=>'sesevent_host','resource_id'=>$item->host_id));
							$favClass = ($favStatus)  ? 'button_active' : '';
							$shareOptions = "<a href='javascript:;' class='sesbasic_icon_btn sesbasic_icon_btn_count sesvideo_favourite_sesevent_host_". $item->host_id." sesbasic_icon_fav_btn sesevent_favourite_sesevent_host ".$favClass ."' data-url=\"$item->host_id\"><i class='fa fa-heart'></i><span>$item->favourite_count</span></a>";
							echo $shareOptions;
						}
          ?>
        </div>
      <?php } ?>
    </div>
    <?php //if(isset($this->titleActive) ){ ?>
      <div class="sesevent_host_list_in_show_title sesevent_animation">
        <?php if(strlen($item->getTitle()) > $this->title_truncation_grid) {
          $title = mb_substr($item->getTitle(),0,($this->title_truncation_grid - 3)).'...';
          echo $this->htmlLink($href,$title ) ?>
        <?php } else { ?>
          <?php echo $this->htmlLink($href,$item->getTitle() ) ?>
        <?php } ?>
      </div>
    <?php //} ?>
    <div class="sesevent_host_list_info sesbasic_clearfix">
      <?php //if(isset($this->titleActive) ){ ?>
	      <div class="sesevent_host_list_name">
	        <?php if(strlen($item->getTitle()) > $this->title_truncation_grid) {
		        $title = mb_substr($item->getTitle(),0,($this->title_truncation_grid - 3)).'...';
		        echo $this->htmlLink($href,$title ) ?>
	        <?php } else { ?>
		        <?php echo $this->htmlLink($href,$item->getTitle() ) ?>
	        <?php } ?>
	      </div>
      <?php //} ?>
      <div class="sesevent_host_list_stats sesevent_list_stats">
        <?php if(isset($this->hostEventCountActive) && isset($hostEventCount)) { ?>
	        <span title="<?php echo $this->translate(array('%s event host', '%s event hosted', $hostEventCount), $this->locale()->toNumber($hostEventCount))?>"><i class="far fa-calendar-alt sesbasic_text_light"></i><?php echo $hostEventCount; ?></span>
        <?php } ?>
        <?php if(isset($this->followActive) && isset($followCount)) { ?>
	        <span title="<?php echo $this->translate(array('%s follow', '%s followed', $followCount), $this->locale()->toNumber($followCount))?>"><i class="fas fa-users sesbasic_text_light"></i><?php echo $followCount; ?></span>
        <?php } ?>
        <?php if(isset($this->viewActive) && isset($item->view_count)) { ?>
	        <span title="<?php echo $this->translate(array('%s view', '%s views', $item->view_count), $this->locale()->toNumber($item->view_count))?>"><i class="fa fa-eye sesbasic_text_light"></i><?php echo $item->view_count; ?></span>
        <?php } ?>
        <?php if(isset($this->favouriteActive) && isset($item->favourite_count)) { ?>
	        <span title="<?php echo $this->translate(array('%s favourite', '%s favourites', $item->favourite_count), $this->locale()->toNumber($item->favourite_count))?>"><i class="fa fa-heart sesbasic_text_light"></i><?php echo $item->favourite_count; ?></span>
        <?php } ?>
      </div>
      <?php if($item->host_phone && isset($this->phoneActive)): ?>
      	<div class="sesevent_host_list_stats sesevent_list_stats">
          <span class="clear sesbasic_clearfix">
            <i class="fa fa-phone sesbasic_text_light"></i>
            <?php echo $item->host_phone ?>
          </span>
 				</div>         
      <?php endif; ?>
    </div>
  </li>
<?php endif; ?>
<?php endforeach; ?>