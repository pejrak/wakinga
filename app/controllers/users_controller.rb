class UsersController < ApplicationController

  before_filter :authenticate_user!

    def show
    @user = User.find(params[:id])
    # If this show page is only for the currently logged in user change it to @user = current_user
    ratingcounter = 0
    @user.posts.each do |sum|
      ratingcounter += sum.rating
    end
    @userratingonbeads = Bead.find_by_sql ["SELECT bp.bead_id as id, bs.title, sum(ps.rating) as rating_sum
    FROM beads_posts bp
    INNER JOIN beads bs ON bs.id = bp.bead_id
    INNER JOIN posts ps ON ps.id = bp.post_id
    WHERE ps.user_id = ?
    GROUP by bead_id
    ORDER by rating_sum DESC
    LIMIT 5", @user.id]
    @userrating = ratingcounter
    @postids = []
    @user.posts.each do |print|
      @postids << print.id
    end
  end

end