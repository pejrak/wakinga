class InterestsController < ApplicationController
before_filter :authenticate_user!
  # GET /interests
  # GET /interests.xml
  def index
	@interests = Interest.all
	respond_to do |format|
	  format.html # index.html.erb
	  format.xml  { render :xml => @interests }
	end
  end

  # GET /interests/1
  # GET /interests/1.xml
  def show
	@interest = Interest.find(params[:id])
	@beadfabric = Beadfabric.new
	for bead_id in @interest.beadthreads
		bead = Bead.find(bead_id)
		@beadfabric << bead
	end
	respond_to do |format|
	  format.html # show.html.erb
	  format.xml  { render :xml => @interest }
	end
  end

  # GET /interests/new
  # GET /interests/new.xml
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
#     @user = User.find(params[:user_id])
#     @bead = Bead.find(params[:bead_id])
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
  
  
  def bf_prepare
  	loadedbead = @beadthreads.find {|beadthreads| beadthread.bead_id == bead_id}
	@beadfabric_prep = Beadfabric.new
  end
end
