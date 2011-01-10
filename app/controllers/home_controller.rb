class HomeController < ApplicationController
  def index
    @interests = current_user.interests.all
    @recentbeads = Bead.order("created_at DESC").limit(3)
    @topbeads = Bead.find_by_sql "SELECT beads_posts.bead_id as id, beads.title, beads.description, count(distinct beads_posts.post_id) as post_count
FROM beads_posts, beads
WHERE beads.id = beads_posts.bead_id
GROUP by bead_id
ORDER by post_count DESC
LIMIT 3"
    cu_ratingcounter = 0
    current_user.posts.each do |sum|
      cu_ratingcounter += sum.rating
    end
    @userrating = cu_ratingcounter
  end

end
