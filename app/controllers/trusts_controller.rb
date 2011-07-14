class TrustsController < ApplicationController
  def index
    @trusts = Trust.all
  end

  def show
    @trust = Trust.find(params[:id])
  end

  def new
    @trust = Trust.new
  end

  def create
    @trust = Trust.new(params[:trust])
    if @trust.save
      flash[:notice] = "Successfully created trust."
      redirect_to @trust.trustee
    else
      render :action => 'new'
    end
  end

  def confirm
    @offered_trust = Trust.find(params[:id])
    interest_offered = @offered_trust.interest
    binding_interest = []
    if @offered_trust.interest.compare_beads_with_other_interests(current_user.interests).present?
      binding_interest = @offered_trust.interest.compare_beads_with_other_interests(current_user.interests).first
    else
      binding_interest = Interest.new(:title => interest_offered.title + " - from trust with #{@offered_trust.trustor.username}", :user_id => @offered_trust.trustee_id)
      binding_interest.beads = interest_offered.beads
      if binding_interest.save
        flash[:notice] = "Adopted interest #{binding_interest.title} through the newly confirmed trust."
      else
        flash[:notice] = "Something went wrong when adopting interest."
      end
    end
    @my_trust = Trust.new(:trustee_id => @offered_trust.trustor.id, :interest_id => binding_interest.id)
    if @my_trust.save
        flash[:notice] = "Trust was confirmed."
        redirect_to binding_interest
      else
        flash[:notice] = "Something went wrong when sealing the trust."
        redirect_to :back
      end
  end

#  def edit
#    @trust = Trust.find(params[:id])
#  end

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
	@user = @trust.interest.user
    @trust.destroy
    flash[:notice] = "Successfully destroyed trust."
    redirect_to @user
  end
end
