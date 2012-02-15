class UserPreferencesController < ApplicationController
before_filter :authenticate_admin!, :except => [:show, :new, :edit, :create, :update, :destroy]
before_filter :authenticate_user!, :except => [:index]

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
    @user_preference = current_user.user_preference
  end

  def update
    @user_preference = current_user.user_preference
    if @user_preference.update_attributes(params[:user_preference])
      redirect_to current_user, :notice  => "Successfully updated user preference."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user_preference = current_user.user_preference
    @user_preference.destroy
    redirect_to root_path, :notice => "Successfully destroyed user preference."
  end
end
