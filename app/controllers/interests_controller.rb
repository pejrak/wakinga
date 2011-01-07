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
  @beads = @interest.beads.all
  postcontentraw = []
  @interest.beads.each do |fb|
    fb.posts.each do |fp|
      postcontentraw << fp
    end
  end
  @postcontent = postcontentraw.uniq

  
#	bead_ids = @interest.beads.find(:all, :select => 'bead_id')

#	for id in loaded_beads
#	@interest.bead_idprep << id
#	end
	respond_to do |format|
	  format.html # show.html.erb
	  format.xml  { render :xml => @interest }
	end
  end

  # GET /interests/new
  # GET /interests/new.xml
#beginning of publish injection
  def publish

	@post = Post.new(params[:post])
	@post.user = current_user
  @interest = Interest.find(params[:id])
  bead_ids = @interest.beads.find(:all, :select => 'bead_id')
#  @interest = Interest.find(params[:interest_id])
#  @post.bead_ids = @interest.bead_ids
  respond_to do |format|
	if @post.save
        flash[:notice] = 'CREATED.'

        format.html { redirect_to(@interest) }
        format.xml { render :xml => @post, :status => :created, :location => @post }

      else
        flash[:notice] = 'FAILED.'
        format.html { render :action => "new" }
        format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

    # end of publish injection
  def new
	@interest = Interest.new

	respond_to do |format|
	  format.html # new.html.erb
	  format.xml  { render :xml => @interest }
	end
  end

  # GET /interests/1/edit
  def edit
	@interest = Interest.find(params[:id])
  end

  # POST /interests
  # POST /interests.xml
  def create
	@interest = Interest.new(params[:interest])
	@interest.user = current_user
	respond_to do |format|
	  if @interest.save
		format.html { redirect_to(interests_path, :notice => 'Interest was successfully created.') }
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
	  format.html { redirect_to(interests_url) }
	  format.xml  { head :ok }
	end
  end
  
  
end
