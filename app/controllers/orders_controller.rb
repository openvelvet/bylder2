class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def sales
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end


  def index
    @orders = Order.all
    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def new
    @order = Order.new
    @profile = Profile.find(params[:profile_id])

    respond_with(@order)
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    @profile = Profile.find(params[:profile_id])
    @seller = @profile.user

    @order.profile_id = @profile.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]

    begin
      charge = Stripe::Charge.create(
        :amount => (@profile.price * 100).floor,
        :currency => "usd",
        :card => token
        )
      flash[:notice] = "Thanks for ordering!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end

    transfer = Stripe::Transfer.create(
        :amount => (@profile.price * 90).floor,
        :currency => "usd",
        :destination => @seller.recipient
        )

    @order.save

    respond_to do |format| 
      if @order.save 
        format.html { redirect_to root_url } 
        format.json { render action: 'show', status: :created, location: @order } 
      else 
        format.html { render action: 'new' } 
        format.json { render json: @order.errors, status: :unprocessable_entity } 
      end 
    end
    
  end

  def update
    @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:address, :city, :state)
    end
end
