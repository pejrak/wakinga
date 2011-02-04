class BeadsInterestsController < ApplicationController
  def index
    @beads_interests = BeadsInterest.all
  end

  def show
    @beads_interest = BeadsInterest.find(params[:id])
  end

  def new
    @beads_interest = BeadsInterest.new
  end

  def create
    @beads_interest = BeadsInterest.new(params[:beads_interest])
    if @beads_interest.save
      flash[:notice] = "Successfully created beads interest."
      redirect_to @beads_interest
    else
      render :action => 'new'
    end
  end

  def edit
    @beads_interest = BeadsInterest.find(params[:id])
  end

  def update
    @beads_interest = BeadsInterest.find(params[:id])
    if @beads_interest.update_attributes(params[:beads_interest])
      flash[:notice] = "Successfully updated beads interest."
      redirect_to beads_interest_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @beads_interest = BeadsInterest.find(params[:id])
    @beads_interest.destroy
    flash[:notice] = "Successfully destroyed beads interest."
    redirect_to beads_interests_url
  end
end
