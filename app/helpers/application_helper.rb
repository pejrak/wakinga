module ApplicationHelper
  def avatar_url(user)
    default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end

  def check_memory(user, content)
    Memorization.where(:user_id => user, :post_id => content).empty?
  end


  def top_beads_overall
    Bead.find(:all,
      :select => 'id, title, description, count(distinct beads_posts.post_id) AS post_counter',
      :joins => :beads_posts,
      :group => ['id','title','description'],
      :order => 'post_counter DESC',
      :limit => 10
    )
  end
  def recent_beads
    Bead.order("created_at DESC").limit(10)
  end

  def active_beads
    Bead.joins(:posts).order("posts.created_at DESC").limit(10).uniq
  end
  
  def current_user_post_owner?(post)
    (current_user == post.user)? true : false
  end

  def character_count(field_id, max_chars, max_char_warning)
    function = "$('##{field_id}').jqEasyCounter({
    'maxChars': #{max_chars},
    'maxCharsWarning': #{max_char_warning},
    'msgFontSize': '10px',
    'msgFontColor': '#000',
    'msgFontFamily': 'Arial',
    'msgTextAlign': 'left',
    'msgWarningColor': '#F00',
    'msgAppendMethod': 'insertAfter'
    });"
    content_for(:head, javascript_include_tag("jquery.jqEasyCharCounter.min")) #append the jquery cc plugin to the head
    return javascript_tag(function) # append the function as script tag
  end

	def outgoing_trusts
		Trust.where(:interest_id => current_user.interests)
	end

	def incoming_trusts
		Trust.where(:trustee_id => current_user)
	end

end
