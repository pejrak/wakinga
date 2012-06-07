module ApplicationHelper

  def title(arg)
    puts 'restricted'
  end

  def pageless(total_pages, url=nil, container=nil)
    opts = {
      :totalPages => total_pages,
      :url => url,
      :loaderMsg => 'loading more messages'
    }
    
    container && opts[:container] ||= container
    
    javascript_tag("$('.dynamic#pagedmessages').pageless(#{opts.to_json});")
  end

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

  def user_tag(selected_user)
    preloaded_trustees_for_selected_user = selected_user.trustees
    if preloaded_trustees_for_selected_user.include?(current_user.id)
      return online_indicator(selected_user)
    #else return 'stat_'
    end
  end


  def outgoing_trusts
    Trust.where(:trustor_id => current_user.id)
  end

  def trusted_interests
    ids = Trust.where(:trustor_id => current_user.id).map(&:interest_id).uniq
    return Interest.where(:id => ids)
    
  end

  def incoming_trusts
    unconfirmed_incoming_trusts = []
    all_incoming_trusts = Trust.where(:trustee_id => current_user.id)
    all_incoming_trusts.each do |t|
      if t.confirmed? == false
        unconfirmed_incoming_trusts << t
      end
    end
    return unconfirmed_incoming_trusts
  end

  private

  def online_indicator(selected_user)
    if selected_user.online?
      return image_tag('/images/status_online.png',:title=>"Last seen #{time_ago_in_words(selected_user.updated_at)} ago.")
    else
      return image_tag('/images/status_offline.png',:title=>"Last seen #{time_ago_in_words(selected_user.updated_at)} ago.")
    end
  end

  def parent_beads_array
    @parent_beads_array = Bead.find_all_by_parent_bead(true)
    #i sort the array of returned beads by the number of interests they contain
    return @parent_beads_array.sort_by {|bead| -BeadsInterest.find(:all, :joins => [:bead, :interest, :user_interest_preferences], :conditions => ['beads.id = ? AND user_interest_preferences.user_id = ? AND interests.i_seal = true', bead.id, current_user.id]).size}
  end

end
