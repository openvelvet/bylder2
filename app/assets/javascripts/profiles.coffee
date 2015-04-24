jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  profile.setupForm()

profile =
  setupForm: ->
    $('#new_profile').submit ->
    		if $('input').length > 8
	        $('input[type=submit]').attr('disabled', true)
	        Stripe.bankAccount.createToken($('#new_profile'), profile.handleStripeResponse)
	        false

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#new_profile').append($('<input type="hidden" name="stripeToken" />').val(response.id))
      $('#new_profile')[0].submit()
    else
      $('#stripe_error').text(response.error.message).show()
      $('input[type=submit]').attr('disabled', false)
