class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:admin]
  before_filter :authenticate_admin!, :except => [:index]
  def index
    @interests = current_user.interests.order('title ASC')
  end

  def admin
    #models = []
    #ObjectSpace.each_object(Module){ |m| models << m if m.ancestors.include?(ActiveRecord::Base) && m != ActiveRecord::Base }
    #@all_models = models.uniq
#    sessions = SessionStore::Session.find(:all, :conditions => ["updated_at >= ?", 15.minutes.ago], :order => "created_at ASC")
#    sessions.each do |session|
#      if session.data[:user]
#        online_users << User.find(session.data[:user])
#      end
#    end
#
#    @online_minds_count = online_users.size
    render :layout => 'administrative'

  end

end
