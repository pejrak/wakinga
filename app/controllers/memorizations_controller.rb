class MemorizationsController < ApplicationController

  def mark_for_action
    @memorization = Memorization.find(params[:id])
    if @memorization.update_attributes(:status_indication => 'action', :change_record => (@memorization.change_record + Memorization::MEMORY_MARKED_ACTION))
      flash[:notice] = 'Marked for future action.'
      respond_to do | format |
        format.js {render :layout => false}
      end
    end
  end

  def mark_for_completion
    @memorization = Memorization.find(params[:id])
    if @memorization.update_attributes(:status_indication => 'complete', :change_record => (@memorization.change_record + Memorization::MEMORY_MARKED_COMPLETE))
      flash[:notice] = 'Marked as complete.'
      respond_to do | format |
        format.js {render :layout => false}
      end
    end
  end
 

  def mark_for_archival
    @memorization = Memorization.find(params[:id])
    if @memorization.update_attributes(:status_indication => 'archive', :change_record => (@memorization.change_record + Memorization::MEMORY_ARCHIVED))
      flash[:notice] = 'Archived.'
      respond_to do | format |
        format.js {render :layout => false}
      end
    end
  end

end
