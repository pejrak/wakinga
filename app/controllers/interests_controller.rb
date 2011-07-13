class InterestsController < ApplicationController
before_filter :authenticate_user!
  # GET /interests
  # GET /interests.xml
  def index
	@interests = current_user.interests.order(post_count)
    redirect_to root_path
	end
  

  # GET /interests/1
  # GET /interests/1.xml
  def show
#    require 'open-uri'
    @interest = Interest.find(params[:id])
    @previous_visit_record = @interest.last_visit_at
    @interest.update_attribute(:last_visit_at, Time.now)

#feed inclusion
#if @interest.feed_url.present?
#  doc = Nokogiri::XML(open(@interest.feed_url))
#    @interest_feed = doc.xpath('//item').map do |i|
#      {'title' => i.xpath('title').inner_text, 'description' => i.xpath('description').text}
#    end
#else @interest_feed = []
#end

	respond_to do |format|
	  format.html # show.html.erb
	  format.xml  { render :xml => @interest }
	end
  end

  def new

    @interest = Interest.new
    @interest.title = 'new interest'
    @parent_beads = Bead.where(:parent_bead => true)
    @beads = Bead.search(params[:search]) - @parent_beads
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interest }
    end
  end

  def edit
    @interest = Interest.find(params[:id])
    if @interest.user == current_user
      @parent_beads = Bead.where(:parent_bead => true)
      @beads = Bead.search(params[:search]) - @parent_beads
    else
        redirect_to :back
        flash[:notice] = 'That is not your interest.'
    end
  end

  def create
	@interest = Interest.new(params[:interest])
	@interest.user = current_user
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
    bead = Bead.find(params[:bead_id])
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
     @adopted_interest = Interest.new(:user_id => current_user.id, :title => @interest.title + ' - ADOPTED')
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
    respond_to do | format |
      format.js
    end
  end

end
