<?php

/**
 * SocialEngineSolutions
 *
 * @category   Application_Sesadvpmnt
 * @package    Sesadvpmnt
 * @copyright  Copyright 2019-2020 SocialEngineSolutions
 * @license    http://www.socialenginesolutions.com/license/
 * @version    $Id: index.tpl  2019-04-25 00:00:00 SocialEngineSolutions $
 * @author     SocialEngineSolutions
 */
 
 ?>
<script src="https://js.stripe.com/v3/"></script>

<div class="layout_middle">
	<div class="generic_layout_container layout_core_content sesbasic_bxs">
  	<div class="sesadvpmnt_stripe_payment_step">
      <div class="sesadvpmnt_stripe_pay_hint_txt"><?php echo $this->translate("Pay with card securely for completing the transaction with Stripe Payment Gateway. We will keep your details confidential.");?></div>
      <div class="sesadvpmnt_stripe_pay_button">
        <b><?php echo  $this->error; ?></b>
        <form action="<?php echo $this->returnUrl ? $this->returnUrl : '';?>" method="POST">
          <script
            src="https://checkout.stripe.com/checkout.js" class="stripe-button"
            data-key="<?php echo $this->publishKey; ?>"
            data-amount="<?php echo $this->amount*100; ?>"
            data-currency="<?php echo $this->currency; ?>"
            data-name="<?php echo $this->title; ?>"
            data-description="<?php echo $this->description; ?>"
            data-image="<?php echo Engine_Api::_()->sesadvpmnt()->getFileUrl($this->logo); ?>"
            data-locale="auto">
          </script>
        </form>
      </div>
		</div>
	</div>
</div>
