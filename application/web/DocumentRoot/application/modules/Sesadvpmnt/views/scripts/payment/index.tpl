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

<!-- placeholder for Elements -->
<div id="card-element">

<form id="payment-form">
  <div class="form-row">
    <!--
      Using a label with a for attribute that matches the ID of the
      Element container enables the Element to automatically gain focus
      when the customer clicks on the label.
    -->
    <label for="ideal-bank-element">
      iDEAL Bank
    </label>
    <div id="ideal-bank-element">
      <!-- A Stripe Element will be inserted here. -->
    </div>
  </div>

  <button>Submit Payment</button>

  <!-- Used to display form errors. -->
  <div id="error-message" role="alert"></div>
</form>
</div>
<script>
  var stripe = Stripe('pk_test_ZGWIW6uxDmFLO0D8fUwRjk1o');
  var elements = stripe.elements();
  var options = {
  // Custom styling can be passed to options when creating an Element
    style: {
      base: {
        padding: '10px 12px',
        color: '#32325d',
        fontSize: '16px',
        '::placeholder': {
          color: '#aab7c4'
        },
      },
    },
  };

  // Create an instance of the idealBank Element
  var idealBank = elements.create('idealBank', options);
  idealBank.mount('#ideal-bank-element');

  var form = document.getElementById('payment-form');
  var accountholderName = document.getElementById('accountholder-name');

  form.addEventListener('submit', function(event) {
    event.preventDefault();

    // Redirects away from the client
    stripe.confirmIdealPayment(
      '<?php echo $this->intent->client_secret; ?>',
      {
        payment_method: {
          ideal: idealBank,
        },
        return_url: "<?php echo $this->intent->return_url; ?>"
      }
    );
  });
</script>

<!-- <button id="checkout-button">Checkout</button>

<script type="text/javascript">
      // Create an instance of the Stripe object with your publishable API key
      var stripe = Stripe("<?php echo $this->publishKey;?>");
      var checkoutButton = document.getElementById('checkout-button');

      checkoutButton.addEventListener('click', function() {
        debugger
        // Create a new Checkout Session using the server-side endpoint you
        // created in step 3.
        // https://www.dandoenwedat.com/sesadvpmnt/payment/index/route/default/type/sesevent_order/order_id/61/gateway_id/8
        fetch("https://www.dandoenwedat.com/sesadvpmnt/payment/newstripe/route/default/type/sesevent_order/order_id/61/gateway_id/8", {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            
          })
        })
        .then(function(response) {
          return response.json();
        })
        .then(function(session) {
          return stripe.redirectToCheckout({ sessionId: session.id });
        })
        .then(function(result) {
          // If `redirectToCheckout` fails due to a browser or network
          // error, you should display the localized error message to your
          // customer using `error.message`.
          if (result.error) {
            alert(result.error.message);
          }
        })
        .catch(function(error) {
          console.error('Error:', error);
        });
      });
    </script>

     -->