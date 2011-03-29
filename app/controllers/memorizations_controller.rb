class MemorizationsController < ApplicationController
  def index
    @memorizations = Memorization.all
  end

  def show
    @memorization = Memorization.find(params[:id])
  end

  def new
    @memorization = Memorization.new
  end

  def create
    @memorization = Memorization.new(params[:memorization])
    if @memorization.save
      flash[:notice] = "Successfully created memorization."
      redirect_to @memorization
    else
      render :action => 'new'
    end
  end

  def edit
    @memorization = Memorization.find(params[:id])
  end

  def update
    @memorization = Memorization.find(params[:id])
    if @memorization.update_attributes(params[:memorization])
      flash[:notice] = "Successfully updated memorization."
      redirect_to memorization_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @memorization = Memorization.find(params[:id])
    @memorization.destroy
    flash[:notice] = "Successfully destroyed memorization."
    redirect_to memorizations_url
  end
end
