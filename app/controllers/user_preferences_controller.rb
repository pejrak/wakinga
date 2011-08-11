class UserPreferencesController < ApplicationController
  def index
    @user_preferences = UserPreference.all
  end

  def show
    @user_preference = current_user.user_preference
  end

  def new
    @user_preference = UserPreference.new
  end

  def create
    unless current_user.user_preference
      @user_preference = UserPreference.new(params[:user_preference])
      @user_preference.user = current_user
      if @user_preference.save
        redirect_to current_user, :notice => "Successfully created user preference."
      else
        render :action => 'new'
      end
    else
      render :action => 'edit', :notice => "You already set your preferences."
    end
  end

  def edit
    @user_preference = UserPreference.find(params[:id])
  end

  def update
    @user_preference = UserPreference.find(params[:id])
    if @user_preference.update_attributes(params[:user_preference])
      redirect_to current_user, :notice  => "Successfully updated user preference."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user_preference = UserPreference.find(params[:id])
    @user_preference.destroy
    redirect_to user_preferences_url, :notice => "Successfully destroyed user preference."
  end
end
