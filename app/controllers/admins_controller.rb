class AdminsController < ApplicationController

  before_filter :authenticate_admin!

  def show
    @admin = Admin.find(params[:id])
  end

  def reset_counts
    @beads = Bead.all
    @beads.each do |bead|
      Bead.reset_counters(bead.id, :beads_posts)
    end
    render '/home/admin'
  end

end