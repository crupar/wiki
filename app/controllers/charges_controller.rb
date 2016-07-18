class ChargesController < ApplicationController

  def create
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: 15_00,
      description: "Premium Membership - #{current_user.email}",
      currency: 'usd'
    )
    current_user.charges.create(
      amount: charge.amount,
      stripe_charge_id: charge.id
    )
    current_user.premium!

    flash[:notice] = "#{current_user.email}, your account has been upgraded to Premium status"
    redirect_to root_path

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership",
      amount: 15_00
    }
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
