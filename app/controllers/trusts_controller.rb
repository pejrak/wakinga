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
      redirect_to @trust.interest.user
    else
      render :action => 'new'
    end
  end

  def edit
    @trust = Trust.find(params[:id])
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
    @trust.destroy
    flash[:notice] = "Successfully destroyed trust."
    redirect_to trusts_url
  end
end
