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

  # GET /interests/new
  # GET /interests/new.xml
#beginning of publish injection
  

    # end of publish injection
  def new

	@interest = Interest.new
  @interest.title = 'new interest'
  @beads = Bead.search(params[:search])
	respond_to do |format|
	  format.html # new.html.erb
	  format.xml  { render :xml => @interest }
	end
  end

  # GET /interests/1/edit
  def edit
	@interest = Interest.find(params[:id])
  @beads = Bead.search(params[:search])
  
  end

  # POST /interests
  # POST /interests.xml
  def create
	@interest = Interest.new(params[:interest])
	@interest.user = current_user
	respond_to do |format|
	  if @interest.save
		format.html { redirect_to edit_interest_path(@interest) }
		format.xml  { render :xml => @interest, :status => :created, :location => @interest }
	  else
		format.html { render :action => "new" }
		format.xml  { render :xml => @interest.errors, :status => :unprocessable_entity }
	  end
	end
  end

  # PUT /interests/1
  # PUT /interests/1.xml
  def update
	@interest = Interest.find(params[:id])

	respond_to do |format|
	  if @interest.update_attributes(params[:interest])
		format.html { redirect_to(@interest, :notice => 'Interest was successfully updated.') }
		format.xml  { head :ok }
	  else
		format.html { render :action => "edit" }
		format.xml  { render :xml => @interest.errors, :status => :unprocessable_entity }
	  end
	end
  end

  # DELETE /interests/1
  # DELETE /interests/1.xml
  def destroy
	@interest = Interest.find(params[:id])
  @interest.destroy

	respond_to do |format|
	  format.html { redirect_to(root_path) }
	  format.xml  { head :ok }
	end
  end

  def add_single_bead
    @interest = Interest.find(params[:id])
    bead = Bead.find(params[:bead_id])
    @interest.beads << bead
    respond_to do |format|
	  format.html { render(:action => 'edit', :notice => 'Bead was added.')}
    end
  end
end