class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    @interests = current_user.interests.limit(30)
    @userratingonbeads = Bead.find_by_sql ["SELECT bp.bead_id as id, bs.title, sum(ps.rating) as rating_sum
    FROM beads_posts bp
    INNER JOIN beads bs ON bs.id = bp.bead_id
    INNER JOIN posts ps ON ps.id = bp.post_id
    WHERE ps.user_id = ?
    GROUP by bead_id
    ORDER by rating_sum DESC
    LIMIT 5", current_user.id]
    cu_ratingcounter = 0
    current_user.posts.each do |sum|
      cu_ratingcounter += sum.rating
    end
    @userrating = cu_ratingcounter
  end

end
