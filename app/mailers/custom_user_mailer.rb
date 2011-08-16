class CustomUserMailer < ActionMailer::Base
  #default :from => "admin@wakinga.com"
  #default_url_options[:host] = request.host

  def send_summary(user)
    @user = user
    @preload_messages = []
    @user.interests.each do |i|
      @preload_messages << i.live_message_content(@user).map(&:id)
      @preload_messages << i.dynamic_post_content(1.day.ago, @user).map(&:id)
    end
    @messages = Post.find_all_by_id(@preload_messages.uniq)
    if @messages.present?
      mail(:to => @user.email, :subject => 'Wakinga daily.', :from => 'admin@wakinga.com')
    end
  end

end
