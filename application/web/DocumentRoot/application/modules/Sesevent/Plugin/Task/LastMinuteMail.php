<?php

/**
 * Class Sesevent_Plugin_Task_LastMinuteMail
 */
class Sesevent_Plugin_Task_LastMinuteMail extends Core_Plugin_Task_Abstract
{
    /**
     * @return Core_Plugin_Job_Abstract|void
     */
    public function execute()
    {
        $viewer = Engine_Api::_()->user()->getViewer();
        $userTable = Engine_Api::_()->getItemTable('user');
        $users = $userTable->fetchAll();
        $eventTable = Engine_Api::_()->getItemTable('event');
        $eventSelect = $eventTable->select()
            ->where('starttime < ? ', date('Y-m-d h:m:s', time() + 3 * 24 * 60 * 60))
            ->where('starttime > ? ', date('Y-m-d h:m:s', time()))
            ->where('is_approved = 1');
        $events = $eventTable->fetchAll($eventSelect);
        foreach ($events as $event) {
            foreach ($users as $user) {
                if ($user->getIdentity() != $event->getOwner()->getIdentity()) {
                    if ($event->is_webinar) {
                        //notify and email to user register its for online event
                        Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification(
                            $user,
                            $viewer,
                            $event,
                            'sesevent_last_minute_online_event',
                            array(
                                'queue' => true
                            )
                        );
                    } elseif (isset($event->region_id)) {
                        //notify and email to user register its for new event in their region
                        if ($user->checkInRegion($event->region_id)) {
                            Engine_Api::_()->getDbtable('notifications', 'activity')->addNotification(
                                $user,
                                $viewer,
                                $event,
                                'sesevent_last_minute_event',
                                array(
                                    'queue' => true
                                )
                            );
                        }
                    }
                }
            }
        }
    }
}