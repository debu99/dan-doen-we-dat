<?php
class Sesevent_Widget_ProfileJoinLeaveController extends Engine_Content_Widget_Abstract {

    public function indexAction() {
        $viewer = Engine_Api::_()->user()->getViewer();
        $this->view->isLoggedIn = $viewer->getIdentity() === 0 ? false: true;

        $event = Engine_Api::_()->core()->getSubject('sesevent_event');
        $this->view->isAttending = $event->membership()->getRow($viewer)->rsvp === 2;

        $this->view->isFull = $event->getAttendingCount() >= $event->max_participants && $event->max_participants !== null;
        $this->view->isOnWaitingList = $event->membership()->getRow($viewer)->rsvp === 5;

        $tickets = Engine_Api::_()->getDbtable('tickets', 'sesevent')->getTicket(array('event_id' => $event->getIdentity()));
        $eventHasTickets = count($tickets) > 0;
        $isHost =  $this->view->isLoggedIn && $event->user_id === $viewer->user_id;
        if($isHost || $eventHasTicket)$this->setNoRender();
    }

}

