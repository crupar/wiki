class SubscriptionsController < ApplicationController

def new
end

def create

    @amount = 1500

  # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
      )

    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- not user_id in app
      amount: @amount,
      description: "Premium Membership - #{current_user.email}",
      currency: 'usd'
      )

    if current_user.update(role: 'premium')
      flash[:success] = "Thank you for upgrading to Premium, #{current_user.email}!"
      redirect_to edit_user_registration_path
    else
      flash[:error] = "There was an error upgrading your account."
      redirect_to edit_user_registration_path
    end

    # Stripe will send back CardErrors, with friendly messages
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
  end


def destroy
  charge = current_user.charges.last
  refund = Stripe::Refund.create(
    charge: charge.stripe_charge_id,
    amount: charge.amount
  )

  if refund.status == 'succeeded'
    current_user.wikis.where(private: true).each do |wiki|
      wiki.update(private: false)
    end
    current_user.standard!
    flash[:notice] = 'Downgrade successful. Account status returned to Standard'
    redirect_to root_path
  end
end

end
