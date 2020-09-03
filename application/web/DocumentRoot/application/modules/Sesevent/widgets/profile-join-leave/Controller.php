<?php
class Sesevent_Widget_ProfileJoinLeaveController extends Engine_Content_Widget_Abstract {

    public function indexAction() {
        $viewer = Engine_Api::_()->user()->getViewer();
        $isLoggedIn = $viewer->getIdentity() === 0 ? false: true;
        $this->view->isLoggedIn = $isLoggedIn;
        if(!$isLoggedIn) return;
       
        $genderUser = $viewer->getGender()['label'];

        $event = Engine_Api::_()->core()->getSubject('sesevent_event');
        $this->view->isAttending = $event->membership()->getRow($viewer)->rsvp === 2;

        $this->view->isFull = $this->eventIsFull($genderUser, $event);
        $this->view->isOnWaitingList = $event->membership()->getRow($viewer)->rsvp === 5;

        $this->view->userIsInAgeRange =  $viewer->userIsInAgeRange($event);

        $tickets = Engine_Api::_()->getDbtable('tickets', 'sesevent')->getTicket(array('event_id' => $event->getIdentity()));
        $eventHasTickets = count($tickets) > 0;
        if($eventHasTickets) {
            $ticketSaleOver = strtotime($tickets[0]->endtime) < strtotime('now');
            $ticketSaleNotStarted = strtotime($tickets[0]->starttime) > strtotime('now');
        }

        $this->view->showLadiesOnly =  $genderUser === "Male" && $event->gender_destribution == "Ladies only";
        $this->view->showMenOnly =  $genderUser === "Female" && $event->gender_destribution == "Men only";
 
        $isHost =  $this->view->isLoggedIn && $event->user_id === $viewer->user_id;
        if($isHost || $eventHasTickets || !$this->view->userIsInAgeRange)$this->setNoRender();
    }

    public function eventIsFull($genderUser, $event){
        if($event->getAttendingCount() >= $event->max_participants && $event->max_participants !== null) return true;

        if(
            $event->gender_destribution === "50/50" && 
            $genderUser === "Male" && 
            $event->male_count >= 0.5 * $event->max_participants
        ) return true;
        else if (
            $event->gender_destribution === "50/50" && 
            $genderUser === "Female" && 
            $event->female_count >= 0.5 * $event->max_participants
        ) return true;

        return false;
    }
}

