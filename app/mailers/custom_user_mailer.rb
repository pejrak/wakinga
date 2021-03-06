class CustomUserMailer < ActionMailer::Base
  default :reply_to => 'admin@wakinga.com'
  default :from => 'admin@wakinga.com'
  #default_url_options[:host] = 'wakinga.com'

  def send_summary(user)
    @user = user
    if @user.user_preference && @user.memorizations
    @preload_messages = []
    @user.user_interest_preferences.each do |i|
      @preload_messages << i.interest.live_message_content(@user).map(&:id)
      @preload_messages << i.interest.dynamic_post_content(1.day.ago, @user).map(&:id)
    end
    @messages = Post.find_all_by_id(@preload_messages.uniq)
    if @messages.size > 0
      mail(:to => @user.email, :subject => 'Wakinga daily.')
    end
    end
  end

end
