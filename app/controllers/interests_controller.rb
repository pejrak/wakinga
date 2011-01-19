class InterestsController < ApplicationController
before_filter :authenticate_user!
  # GET /interests
  # GET /interests.xml
  def index
	@interests = current_user.interests.all
	
    postcounter = []
    beadcounter = []
    @interests.each do |ic|
      ic.beads.each do |bc|
      bc.posts.each do |pc|
        postcounter << pc
      end
      end
    end
    @postcount = postcounter.uniq
    respond_to do |format|
	  format.html # index.html.erb
	  format.xml  { render :xml => @interests }
	end
  end

  # GET /interests/1
  # GET /interests/1.xml
  def show
	@interest = Interest.find(params[:id])
#loading content for all posts related to the selected interest
  @postcontent = Post.find_by_sql ["SELECT DISTINCT ps.id, ps.title, content, ps.created_at, ps.updated_at, ps.user_id, ps.rating
  FROM posts ps
    INNER JOIN beads_posts bps ON bps.post_id = ps.id
    INNER JOIN beads_interests bis ON bis.bead_id = bps.bead_id
    WHERE bis.interest_id = ?
    ORDER by ps.updated_at DESC", @interest.id]

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