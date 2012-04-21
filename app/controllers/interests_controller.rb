class InterestsController < ApplicationController
before_filter :authenticate_user!

  def index
    @interests = current_user.users_prefered_interests
    respond_to do |format|
      format.json {render :json => @interests}
    end
  end

  def show
    @interest = Interest.find(params[:id])
    if @interest.preference_for(current_user)
      @previous_visit_record = @interest.preference_for(current_user).last_visit_at
      @interest.preference_for(current_user).update_attribute(:last_visit_at, Time.now)
    else
      @previous_visit_record = current_user.last_sign_in_at
    end
    if session[:loaded_interests].present?
    #put cookie stored interests 
    inter_load = session[:loaded_interests]
    session[:loaded_interests] = []
    # purify the cookied interests that are not found
    inter_load.each {|i| (Interest.where(:id=>i)==[])? (inter_load.delete(i)) : ""}
    (inter_load.size > 4)? (session[:loaded_interests] = inter_load.drop(1)) : (session[:loaded_interests] = inter_load)
      unless session[:loaded_interests].include?(@interest.id)
        session[:loaded_interests] << @interest.id
      end
    else
      session[:loaded_interests] = []
      session[:loaded_interests] << @interest.id
    end
    @messages_size = @interest.post_content(current_user).size
    @memories_size = @interest.memorized_post_content(true,current_user,'other').size
    @tabs = session[:loaded_interests]
    respond_to do |format|
      format.js
      #format.xml  { render :xml => @interest }
    end
  end

  def new
    @interest = Interest.new
    @interest.title = 'new interest'
    if params[:parent_bead_id]
      @interest.beads << Bead.find(params[:parent_bead_id])

      if @interest.save
        redirect_to edit_interest_path(@interest)
      else
        respond_to do |format|
          format.html
          format.xml  { render :xml => @interest }
        end
      end
    else
      redirect_to root_path
      flash[:notice] = 'You need to create interest with parent bead.'
    end
  end

  def edit
    @interest = Interest.find(params[:id])
    @parent_beads = Bead.where(:parent_bead => true) - @interest.beads
    if @interest.i_seal == true
      redirect_to root_path
      flash[:notice] = 'The interest is sealed already.'
    end
  end

  def create
    @interest = Interest.new(params[:interest])

    respond_to do |format|
      if @interest.save
        format.html { redirect_to edit_interest_path(@interest) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @interest = Interest.find(params[:id])

    respond_to do |format|
    if @interest.parent_beads.present?
      if @interest.update_attributes(params[:interest])
        @interest.update_attribute(:i_seal, true)
        @interest.update_attribute(:title, @interest.title_with_beads)
        @user_interest_preferrence = UserInterestPreference.create(:user_id => current_user.id, :interest_id => @interest.id, :i_private => false, :last_visit_at => Time.now)
        format.html { redirect_to(@interest, :notice => 'Interest was successfully set up.') }
      else
      format.html { render :action => "edit" }
      end
    else
      format.html { redirect_to(:action => "edit") }
      flash[:notice] = 'You will need to select some parent beads.'
    end
    end
  end

  def destroy
    @interest = Interest.find(params[:id])
    if @interest.preference_for(current_user)
      @interest.preference_for(current_user).destroy
    end
    if @interest.i_seal == false
      @interest.destroy
    end
    respond_to do |format|
      format.html { redirect_to(root_path) }
      flash[:notice] = 'Interest abandoned.'
    end
  end

  def add_single_bead
    if params[:bead_id]
      @bead = Bead.find(params[:bead_id])
    elsif params[:noun_id]
      @noun = Noun.find(params[:noun_id])
      (Bead.where('UPPER(beads.title) = UPPER(?)',@noun.title)==[])? (@bead = Bead.create(:title => @noun.title.titleize, :description => 'Newly activated bead.', :parent_bead => 0)) && (@noun.update_attributes(:b_active => 1)) : (@bead = Bead.where('UPPER(beads.title) = UPPER(?)',@noun.title).first)
    end
    #if the @interest instance is coming from the edit interest form
    unless params[:parent_bead_id]
      @interest = Interest.find(params[:id])
      if @interest.beads.include?(@bead)
      flash[:notice] = 'The bead is already added.'
      else
        #here I am limiting the number of allowed beads in interest... to 4
        if @interest.beads.size < 2
          @interest.beads << @bead
        else
          flash[:notice] = 'You can only add up to 2 concepts to an interest.'
        end
      end
      respond_to do |format|
        format.html { redirect_to edit_interest_path(@interest) }
      end
    else
      @parent_bead = Bead.find(params[:parent_bead_id])
      @new_interest = Interest.create(:title => @parent_bead.title+' -new')
      @new_interest.beads << @parent_bead
      @new_interest.beads << @bead
      redirect_to edit_interest_path(@new_interest)
      
    end
  end

  def add_beads
    @interest = Interest.find(params[:id])
    beads = Bead.where(:id => params[:bead_ids])
    @interest.beads << beads
    respond_to do |format|
	  format.html { redirect_to edit_interest_path(@interest) }
    end
  end


  def remove_single_bead
    @interest = Interest.find(params[:id])
    bead = Bead.find(params[:bead_id])
    unless bead.parent_bead == true && @interest.beads.find_all_by_parent_bead(true).count <= 1
    @interest.beads.delete(bead)
      flash[:notice] = 'Bead removed.'
      respond_to do |format|
      format.html { redirect_to edit_interest_path(@interest) }
      end
    else
      flash[:notice] = 'You cannot remove the last parent concept.'
      respond_to do |format|
      format.html { redirect_to edit_interest_path(@interest) }
      end
    end
  end

  def adopt
    
   @interest = Interest.find(params[:id])
   unless @interest.preference_for(current_user)
     @user_interest_preferrence = UserInterestPreference.create(:user_id => current_user.id, :interest_id => @interest.id, :i_private => false, :last_visit_at => Time.now)
   end
   redirect_to interest_path(@interest)
  end

#preview action enables you to view the interest details with javascript

  def preview
    @interest = Interest.find(params[:id])
    @sharing_user_ids = @interest.users_sharing_the_same_interest.uniq
    @shared_by_this_many_users = @sharing_user_ids.size

    respond_to do | format |
      format.js
    end
  end
  
  def load_suggestions
    @interest = Interest.find(params[:id])
    selection_size = @interest.beads.size
    if selection_size > 0
      (selection_size < 4)? @single_suggestions = @interest.nearest_beads_combination(selection_size + 1) : @single_suggestions = nil
      #(selection_size < 3)? @double_suggestions = @interest.nearest_beads_combination(selection_size + 2) : @double_suggestions = nil
      #(selection_size < 2)? @triple_suggestions = @interest.nearest_beads_combination(selection_size + 3) : @triple_suggestions = nil
    end
    respond_to do | format |
      format.js
    end
  end
  
  def memory_search
    @interest = Interest.find(params[:id])
    memory_array = @interest.memorized_post_content(true,current_user,'other').map(&:id)
    @search_results = Post.search(params[:memorysearch],memory_array)
    @previous_visit_record = @interest.preference_for(current_user).last_visit_at
    respond_to do |format|
      format.js
    end
  end
  
  def remove_tab
    session[:loaded_interests].delete(params[:id].to_i)
    redirect_to root_path
  end

  def switch_privacy
    @interest = Interest.find(params[:id])
    @user_preference = @interest.preference_for(current_user)

    (@user_preference.i_private == false)? @user_preference.i_private = true : @user_preference.i_private = false
    if @user_preference.save
      redirect_to @interest
    else
      flash[:notice] = 'Unable to switch.'
      redirect_to root_path
    end
  end

end
