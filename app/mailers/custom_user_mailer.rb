class CustomUserMailer < ActionMailer::Base
  default :from => "wakingamail@gmail.com"

  def send_summary(user)
    @user = user
    mail(:to => @user.email, :subject => 'Wakinga daily.')

  end

end
