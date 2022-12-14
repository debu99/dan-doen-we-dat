<?php
/**
 * SocialEngine
 *
 * @category   Application_Extensions
 * @package    Group
 * @copyright  Copyright 2006-2010 Webligo Developments
 * @license    http://www.socialengine.com/license/
 * @version    $Id: index.tpl 9747 2012-07-26 02:08:08Z john $
 * @author		 Sami
 */
?>

<script type="text/javascript">
  en4.core.runonce.add(function(){

    <?php if( !$this->renderOne ): ?>
    var anchor = $('profile_groups_events').getParent();
    $('profile_groups_events_previous').style.display = '<?php echo ( $this->paginator->getCurrentPageNumber() == 1 ? 'none' : '' ) ?>';
    $('profile_groups_events_next').style.display = '<?php echo ( $this->paginator->count() == $this->paginator->getCurrentPageNumber() ? 'none' : '' ) ?>';

    $('profile_groups_events_previous').removeEvents('click').addEvent('click', function(){
      en4.core.request.send(new Request.HTML({
        url : en4.core.baseUrl + 'widget/index/content_id/' + <?php echo sprintf('%d', $this->identity) ?>,
        data : {
          format : 'html',
          subject : en4.core.subject.guid,
          page : <?php echo sprintf('%d', $this->paginator->getCurrentPageNumber() - 1) ?>
        }
      }), {
        'element' : anchor
      })
    });

    $('profile_groups_events_next').removeEvents('click').addEvent('click', function(){
      en4.core.request.send(new Request.HTML({
        url : en4.core.baseUrl + 'widget/index/content_id/' + <?php echo sprintf('%d', $this->identity) ?>,
        data : {
          format : 'html',
          subject : en4.core.subject.guid,
          page : <?php echo sprintf('%d', $this->paginator->getCurrentPageNumber() + 1) ?>
        }
      }), {
        'element' : anchor
      })
    });
    <?php endif; ?>
  });
</script>

<div class="group_album_options">
  <?php if( $this->canAdd ): ?>
    <?php echo $this->htmlLink(array(
        'route' => 'event_general',
        'controller' => 'event',
        'action' => 'create',
        'parent_type'=> 'group',
        'subject_id' => $this->subject()->getIdentity(),
      ), $this->translate('Add Events'), array(
        'class' => 'buttonlink icon_group_photo_new'
    )) ?>
  <?php endif; ?>
</div>

<br />

<?php if( $this->paginator->getTotalItemCount() > 0 ): ?>

  <ul id="profile_groups_events" class="events_browse grid_wrapper">
    <?php foreach( $this->paginator as $event ): ?>
      <li>
        <div class='groups_profile_tab_photo'>
          <?php echo $this->htmlLink($event->getHref(), $this->itemPhoto($event, 'thumb.profile')) ?>
          <div class="events_held_info">
            <i class="fa fa-calendar"></i>
            <span class="event_start_date"> <?php echo $this->locale()->toDateTime($event->starttime) ?></span>
          </div>
        </div>
        <div class='groups_profile_tab_info'>
          <div class="groups_profile_tab_title">
            <?php echo $this->htmlLink($event->getHref(), $this->string()->chunk($event->getTitle(), 10)) ?>
          </div>
          <span class="groups_profile_tab_members">
              <?php echo $this->translate(array('%s guest', '%s guests', $event->membership()->getMemberCount()),$this->locale()->toNumber($event->membership()->getMemberCount())) ?>
            <?php echo $this->translate('led by') ?>
            <?php echo $this->htmlLink($event->getOwner()->getHref(), $event->getOwner()->getTitle()) ?>
          </span>
          <div class="groups_profile_tab_desc">
            <?php echo $event->getDescription() ?>
          </div>
        </div>
      </li>
    <?php endforeach;?>
  </ul>

    <div>
      <div id="profile_groups_events_previous" class="paginator_previous">
        <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Previous'), array(
          'onclick' => '',
          'class' => 'buttonlink icon_previous'
        )); ?>
      </div>
      <div id="profile_groups_events_next" class="paginator_next">
        <?php echo $this->htmlLink('javascript:void(0);', $this->translate('Next'), array(
          'onclick' => '',
          'class' => 'buttonlink_right icon_next'
        )); ?>
      </div>
    </div>

<?php else: ?>

  <div class="tip">
    <span>
      <?php echo $this->translate('No events have been added to this group yet.');?>
    </span>
  </div>

<?php endif; ?>
