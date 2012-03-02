desc "Task for distribution of wakinga daily"
task :cron => :environment do

  User.where('role = ? AND last_sign_in_at < ?','guest',1.day.ago).each do |g|
    g.destroy
  end
  User.where(:role => 'regular').each do |u|
    if u.user_preference && u.memorizations
    @preload_messages = []
    u.user_interest_preferences.each do |i|
      @preload_messages << i.interest.live_message_content(u).map(&:id)
      @preload_messages << i.interest.dynamic_post_content(1.day.ago, u).map(&:id)
    end
    @messages = Post.find_all_by_id(@preload_messages.uniq)
    if u.memorizations.count > 0 && u.user_preference.subscription_preference != 'None' && @messages.size > 0
      if u.user_preference.subscription_preference == 'Daily'
        CustomUserMailer.send_summary(u).deliver
      elsif u.user_preference.subscription_preference == 'Weekly'
        if Date.today.wday == 2
          CustomUserMailer.send_summary(u).deliver
        end
      end
    end
  end
  end
end
