class RegistrationsController < Devise::RegistrationsController
  def create
    if session[:omniauth] or verify_recaptcha
      super
      session[:omniauth] = nil unless @user.new_record?
      @new_user_preference = UserPreference.create(:user_id => @user.id, :messages_per_page => 30, :subscription_preference => 'Weekly')
    else
      flash[:alert] = "There was an error with the details provided below."
      render_with_scope :new
    end
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @no_need_for_recaptcha = true
      #no need to validate the user yet, this is a fresh new user form, with omniauth session variables added in order to create authentication later
      #@user.valid?
    end
  end
end
