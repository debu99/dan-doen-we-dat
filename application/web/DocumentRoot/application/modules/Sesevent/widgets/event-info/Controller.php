<?php
/**
 * SocialEngineSolutions
 *
 * @category   Application_Sesevent
 * @package    Sesevent
 * @copyright  Copyright 2015-2016 SocialEngineSolutions
 * @license    http://www.socialenginesolutions.com/license/
 * @version    $Id: Controller.php 2016-07-26 00:00:00 SocialEngineSolutions $
 * @author     SocialEngineSolutions
 */
class Sesevent_Widget_EventInfoController extends Engine_Content_Widget_Abstract {

  public function indexAction() {
    // Get subject and check auth
    $viewer = Engine_Api::_()->user()->getViewer();

    $isLoggedIn = $viewer->getIdentity() === 0 ? false: true;
    $this->view->isLoggedIn = $isLoggedIn;
    
    $subject = Engine_Api::_()->core()->getSubject('sesevent_event');
    if (!$subject) {
      return $this->setNoRender();
    }
    $this->view->subject = $subject;
    $this->view->eventTags = $subject->tags()->getTagMaps();

    $isAttending = $subject->membership()->getRow($viewer)->rsvp === 2;;
    $this->view->isAttending = $isAttending;
    $this->view->event_title = $subject->title;
    $this->view->age_from = $subject->age_category_from;
    $this->view->age_to = $subject->age_category_to;
    $this->view->max_participants = $subject->max_participants;
    $this->view->min_participants = $subject->min_participants;
    $attending = count(Engine_Api::_()->getDbtable('membership', 'sesevent')->getMembership(array('event_id'=>$subject->getIdentity(),'type'=>'attending')));
    $this->view->available_spots = $subject->max_participants - $attending;
    
    $this->view->short_location = $this->shortLocation($subject->location);
    $this->view->location = $isAttending? $subject->location: $this->shortLocation($subject->location);
    $this->view->venue = strlen($subject->venue_name) > 0? $subject->venue_name: false;
    $category = Engine_Api::_()->getItem('sesevent_category',$subject->category_id);
    $catIcon = Engine_Api::_()->storage()->get($category->cat_icon);
    if($catIcon)  $this->view->catIcon =  $catIcon->getPhotoUrl('thumb.icon');

    $curArr = Zend_Locale::getTranslationList('CurrencySymbol');

    if($subject->is_additional_costs) {
      $this->view->additional_costs = true;
      $this->view->additional_costs_amount = $subject->additional_costs_amount;
      $this->view->additional_costs_amount_currency = $curArr[$subject->additional_costs_amount_currency];
      $this->view->additional_costs_description = $subject->additional_costs_description;
    }

    $this->view->meeting_point = $subject->meeting_point? $subject->meeting_point: false;
    $this->view->meeting_time = $subject->meeting_time? $subject->meeting_time: false;
    $this->view->tel_host = $subject->tel_host? $subject->tel_host: false;


    $this->eventOngoing = strtotime($subject->endtime) > strtotime('now');
    if($subject->gender_destribution === "50/50" || 
       $subject->gender_destribution === "Ladies only" || 
       $subject->gender_destribution === "Men only"
    ) 
      $this->view->gender_destribution = $subject->gender_destribution;
    else 
     $this->view->gender_destribution = false;
  }
    
    
    function shortLocation($location){

      $splitLocation = explode(",",$location);
      $locationLength = count($splitLocation);
      if(count($splitLocation) === 1){
        return trim($splitLocation[0]);
      } else {
        return trim($splitLocation[$locationLength - 2]) . ", " . trim($splitLocation[$locationLength-1]);
      }
    }
}
