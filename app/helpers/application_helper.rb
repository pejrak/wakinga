module ApplicationHelper
  def avatar_url(user)
    default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end

  def check_memory(user, content)
    Memorization.where(:user_id => user, :post_id => content).empty?
  end

#function to retrieve interests of users other than the selected user, useful for displaying properties of other interests
  def retrieve_others_interests(selected_user)
    Interest.where('interests.user_id <> ?',selected_user)
  end

  def live_messages(selected_user_id)
    Post.find(:all, :include => [:comments, :memorizations], :conditions => ['memorizations.updated_at < comments.updated_at AND posts.user_id = ?', selected_user_id])
  end


  def interests_with_live_messages(selected_user_id)
    loaded_live_messages = live_messages(selected_user_id)
    loaded_interests = Interest.find_all_by_user_id(selected_user_id) 
    loaded_live_messages.each do |lm|
      puts "here goes the magic"
    end
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
		unconfirmed_incoming_trusts = []
    all_incoming_trusts = Trust.where(:trustee_id => current_user)
    all_incoming_trusts.each do |t|
      if t.confirmed? == false
        unconfirmed_incoming_trusts << t
      end
    end
    return unconfirmed_incoming_trusts
	end

end
