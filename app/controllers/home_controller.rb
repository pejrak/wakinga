class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:administrative]
  before_filter :authenticate_admin!, :except => [:index]
  def index
    @interests = current_user.interests.order('title ASC')
  end

  def administrative
    models = []
    ObjectSpace.each_object(Module){ |m| models << m if m.ancestors.include?(ActiveRecord::Base) && m != ActiveRecord::Base }
    @all_models = models.uniq
    render :layout => 'administrative'

  end

end
