desc "Task for distribution of wakinga daily"
task :cron => :environment do
  User.each do |u|
    if u.memorizations.count > 0 && u.user_preference.subscription_preference != 'None'
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
