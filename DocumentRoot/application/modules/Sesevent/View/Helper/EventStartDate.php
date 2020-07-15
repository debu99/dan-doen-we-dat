<?php
/**
 * SocialEngineSolutions
 *
 * @category   Application_Sesevent
 * @package    Sesevent
 * @copyright  Copyright 2015-2016 SocialEngineSolutions
 * @license    http://www.socialenginesolutions.com/license/
 * @version    $Id: eventStartDate.php 2020-07-14 00:00:00 SocialEngineSolutions $
 * @author     Jurgen Tonneyck
 */
class Sesevent_View_Helper_EventStartDate extends Sesevent_View_Helper_EventStartEndDates {

	public function eventStartDate($sesevent){

		setlocale(LC_ALL, 'Dutch');

		$timeformat = Engine_Api::_()->getApi('settings', 'core')->getSetting('sesevent.datetimeformate', 'medium');
		$starttime = $this->changeEventDateTime($sesevent->starttime,array('timezone'=>$sesevent->timezone,'size'=>$timeformat));
		
		$day = substr(date('l', strtotime($sesevent->starttime)),0,3);
		$date = date('d', strtotime($sesevent->starttime));
		$month = date('M', strtotime($sesevent->starttime));
		$formattedHTML  = "<div class='seevent-cover-date'>";
		$formattedHTML .=	"<h1 class='seevent-cover-date--day'>$day</h1>";
		$formattedHTML .=	"<h1 class='seevent-cover-date--date'>$date</h1>";
		$formattedHTML .= 	"<h1 class='seevent-cover-date--month'>$month</h1>";
		$formattedHTML .= "</div>";
		return $formattedHTML;
	}
}