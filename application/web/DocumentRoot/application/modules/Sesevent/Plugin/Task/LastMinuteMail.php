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
        $eventTable = Engine_Api::_()->getItemTable('event');
    }
}