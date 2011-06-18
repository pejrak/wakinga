class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:admin]
  before_filter :authenticate_admin!, :except => [:index]
  def index
    @interests = current_user.interests.order('title ASC')
  end

  def admin
    models = []
    ObjectSpace.each_object(Module){ |m| models << m if m.ancestors.include?(ActiveRecord::Base) && m != ActiveRecord::Base }
    @all_models = models.uniq
    render :layout => 'admin'

  end

end
