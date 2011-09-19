class InterestsController < ApplicationController
before_filter :authenticate_user!
  # GET /interests
  # GET /interests.xml
  def index
#	@interests = current_user.interests.order(post_count)
    redirect_to root_path
	end
  

  # GET /interests/1
  # GET /interests/1.xml
  def show
#    require 'open-uri'

    @interest = Interest.find(params[:id])
    @previous_visit_record = @interest.last_visit_at
    if current_user == @interest.user
      @interest.update_attribute(:last_visit_at, Time.now)
    end
    if session[:loaded_interests].present?
    #put cookie stored interests 
    inter_load = session[:loaded_interests]
    session[:loaded_interests] = []
    # purify the cookied interests that are not found
    inter_load.each {|i| (Interest.where(:id=>i)==[])? (inter_load.delete(i)) : ""}
    (inter_load.size > 5)? (session[:loaded_interests] = inter_load.drop(1)) : (session[:loaded_interests] = inter_load)
      unless session[:loaded_interests].include?(@interest.id)
        session[:loaded_interests] << @interest.id
      end
    else
      session[:loaded_interests] = []
      session[:loaded_interests] << @interest.id
    end


	respond_to do |format|
	  format.html # show.html.erb
	  format.xml  { render :xml => @interest }
	end
  end

  def new
    @interest = Interest.new
    @interest.title = 'new interest'
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interest }
    end
  end

  def edit
    @interest = Interest.find(params[:id])
    if @interest.user == current_user
      @parent_beads = Bead.where(:parent_bead => true) - @interest.beads
#      @search = Bead.search(params[:search]) - (@parent_beads + @interest.beads)
#      @beads = @search - (@parent_beads + @interest.beads)
    else
        redirect_to :back
        flash[:notice] = 'That is not your interest.'
    end
  end

  def create
	@interest = Interest.new(params[:interest])
	@interest.user = current_user
	@interest.last_visit_at = Time.now
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
    if @interest.beads.present?
      if @interest.update_attributes(params[:interest])
      format.html { redirect_to(@interest, :notice => 'Interest was successfully updated.') }
      format.xml  { head :ok }
      else
      format.html { render :action => "edit" }
      format.xml  { render :xml => @interest.errors, :status => :unprocessable_entity }
      end
    else
      format.html { redirect_to(:action => "edit") }
      flash[:notice] = 'You will need to select some beads.'
    end
    end
  end

  def destroy
	@interest = Interest.find(params[:id])
  @interest.destroy

	respond_to do |format|
	  format.html { redirect_to(root_path) }

    flash[:notice] = 'Interest removed.'
	end
  end

  def add_single_bead
    @interest = Interest.find(params[:id])
    if params[:bead_id]
      bead = Bead.find(params[:bead_id])
    elsif params[:noun_id]
      @noun = Noun.find(params[:noun_id])
      (Bead.where('UPPER(beads.title) = UPPER(?)',@noun.title)==[])? (bead = Bead.create(:title => @noun.title.titleize, :description => 'Newly activated bead.', :parent_bead => 0)) && (@noun.update_attributes(:b_active => 1)) : (bead = Bead.where('UPPER(beads.title) = UPPER(?)',@noun.title).first)
    end
    
    if @interest.beads.include?(bead)
      flash[:notice] = 'The bead is already added.'
    else
      #here I am limiting the number of allowed beads in interest... to 4
      if @interest.beads.size < 4
        @interest.beads << bead
      else

        flash[:notice] = 'You can only add up to 4 beads to an interest.'
      end
      
    end
   
    respond_to do |format|
	  format.html { redirect_to edit_interest_path(@interest) }
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
    @interest.beads.delete(bead)
	flash[:notice] = 'Bead removed.'
    respond_to do |format|
	  format.html { redirect_to edit_interest_path(@interest) }
    end
  end

   def adopt
     @interest = Interest.find(params[:id])
     @adopted_interest = Interest.new(:user_id => current_user.id, :title => "Adopted interest - rename", :last_visit_at => Time.now, :i_private => false)
     @adopted_interest.beads = @interest.beads
     if @adopted_interest.save
       flash[:notice] = 'The interest was adopted.'
     else flash[:notice] = 'Something went wrong.'
     end
     redirect_to root_path
     
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
    memory_array = @interest.memorized_post_content(true,current_user).map(&:id)
    @search_results = Post.search(params[:memorysearch],memory_array)
    @previous_visit_record = @interest.last_visit_at
    respond_to do |format|
      format.js
    end
  end

end
