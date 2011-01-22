module ApplicationHelper
  def avatar_url(user)
    default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end

  def readable_text_area(form, method, options = {})
    form.text_area(method, "cols" => 40, "rows" => 5)
  end
  
end
