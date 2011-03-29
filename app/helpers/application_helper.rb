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
      :limit => 5
    )
  end
  def recent_beads
    Bead.order("created_at DESC").limit(3)
  end
  


  #character count method declaration, from: http://snippets.dzone.com/posts/show/2875




end
