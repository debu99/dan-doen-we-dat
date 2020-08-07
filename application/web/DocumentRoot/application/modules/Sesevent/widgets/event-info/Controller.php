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
    $subject = Engine_Api::_()->core()->getSubject('sesevent_event');
    if (!$subject) {
      return $this->setNoRender();
    }
    $this->view->subject = $subject;
    $this->view->eventTags = $subject->tags()->getTagMaps();

    $isAttending = $subject->membership()->getRow($viewer)->rsvp === 2;;
    $this->view->isAttending = $isAttending;

    $this->view->age_from = $subject->age_category_from;
    $this->view->age_to = $subject->age_category_to;
    $this->view->max_participants = $subject->max_participants;
    $this->view->min_participants = $subject->min_participants;
    $attending = count(Engine_Api::_()->getDbtable('membership', 'sesevent')->getMembership(array('event_id'=>$subject->getIdentity(),'type'=>'attending')));
    $this->view->available_spots = $subject->min_participants - $attending;
    
    $this->view->short_location = $this->shortLocation($subject->location);
    $this->view->location = $isAttending? $subject->location: $this->shortLocation($subject->location);
    $this->view->venue = strlen($subject->venue_name) > 0? $subject->venue_name: false;

    $curArr = Zend_Locale::getTranslationList('CurrencySymbol');

    if($subject->is_additional_costs) {
      $this->view->additional_costs = true;
      $this->view->additional_costs_amount = $subject->additional_costs_amount;
      $this->view->additional_costs_amount_currency = $curArr[$subject->additional_costs_amount_currency];
      $this->view->additional_costs_description = $subject->additional_costs_description;
    }

    if($subject->gender_destribution === "Ladies only" || $subject->gender_destribution === "Men only") 
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
