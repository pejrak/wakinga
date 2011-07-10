class AdminsController < ApplicationController

  before_filter :authenticate_admin!

  def show
    @admin = Admin.find(params[:id])
  end

  def reset_counts
    @beads = Bead.all
    @beads.each do |bead|
      bead.update_attributes(:beads_posts_count => bead.beads_posts.size)
      bead.save
      if bead.save
        flash[:notice] = 'succesful.'
      end
    end
    render '/home/admin'
  end

end