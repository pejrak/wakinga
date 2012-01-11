class AuthenticationsController < ApplicationController
  def index
    if current_user
      @authentications = current_user.authentications
    end
  end

  def create
    omniauth = request.env["omniauth.auth"]
    hash_record = Request.new(:r_type => 'access_request', :r_title => 'recorded', :r_description => omniauth.to_yaml )
    hash_record.save
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def guest_login
    username = 'guest' + (Time.now.to_i).to_s
    email = username + '@wakinga.com'
    @guest = User.new(:username => username, :email => email, :password => email, :role => 'guest')
    if @guest.save
      @new_user_preference = UserPreference.create(:user_id => @guest.id, :messages_per_page => 30, :subscription_preference => 'None')
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, @guest)
    else
      flash[:notice] = "Unsuccessful."
    end

  end

  def destroy

    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url

  end
end
