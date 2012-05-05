class TrustsController < ApplicationController
before_filter :authenticate_admin!, :except => [:show, :new, :edit, :create, :update, :destroy, :confirm, ]
before_filter :authenticate_user!, :except => [:index]

#  def index
#    @trusts = Trust.all
#  end

#  def show
#    @trust = Trust.find(params[:id])
#  end

#  def new
#    @trust = Trust.new
#  end

  def create
    @trust = Trust.new
    @trust.interest = Interest.find(params[:trust][:interest_id])
    @trust.trustee = User.find(params[:trust][:trustee_id])
    @trust.trustor = current_user
    duplicate_exists = Trust.where(:interest_id => @trust.interest, :trustor_id => @trust.trustor, :trustee_id => @trust.trustee)
    if !duplicate_exists && @trust.save
      if @trust.confirmed? == true
        flash[:notice] = "Successfully bound trust."
      else
        flash[:notice] = "Trust proposed."
      end
    else
      flash[:notice] = "Trust already exists."
    end
    redirect_to @trust.interest
  end

  def confirm
    @offered_trust = Trust.find(params[:id])
    binding_interest = @offered_trust.interest
    @my_trust = Trust.new(:trustee_id => @offered_trust.trustor.id, :interest_id => binding_interest.id, :trustor_id => current_user.id)
    unless binding_interest.preference_for(current_user).present?
      @user_interest_preferrence = UserInterestPreference.create(:user_id => current_user.id, :interest_id => binding_interest.id, :i_private => false, :last_visit_at => Time.now)
    end
    if @my_trust.save
        flash[:notice] = "Trust was confirmed."
        redirect_to binding_interest
      else
        flash[:notice] = "Something went wrong when sealing the trust."
        redirect_to :back
      end
  end

  def update
    @trust = Trust.find(params[:id])
    if @trust.update_attributes(params[:trust])
      flash[:notice] = "Successfully updated trust."
      redirect_to home_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @trust = Trust.find(params[:id])
	@interest = @trust.interest
    @trust.destroy
    flash[:notice] = "Successfully destroyed trust."
    redirect_to @interest
  end

  def propose
    @trust = Trust.new
    @trust.trustor_id = current_user.id
    @trust.trustee_id = params[:trustee_id]
    @trust.interest_id = params[:interest_id]
    if @trust.save
      redirect_to @interest
    end
  end
end
