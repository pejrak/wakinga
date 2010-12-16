class BeadfabricsController < ApplicationController
before_filter :authenticate_user!
  # GET /beadfabrics
  # GET /beadfabrics.xml
  def index
    @beadfabrics = Beadfabric.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @beadfabrics }
    end
  end

  # GET /beadfabrics/1
  # GET /beadfabrics/1.xml
  def show
    @beadfabric = Beadfabric.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @beadfabric }
    end
  end

  # GET /beadfabrics/new
  # GET /beadfabrics/new.xml
  def new
    @beadfabric = Array.new(3) {Beadfabric.new}

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @beadfabric }
    end
  end

  # GET /beadfabrics/1/edit
  def edit
    @beadfabric = Beadfabric.find(params[:id])
  end

  # POST /beadfabrics
  # POST /beadfabrics.xml
  def create
#     @post = Post.find(params[:post_id])
#     @bead = Bead.find(params[:bead_id])
    @beadfabrics = params[:beadfabrics].values.collect { |beadfabric| Beadfabric.new(beadfabric) }
#    @beadfabric = Beadfabric.new(params[:beadfabric])
    respond_to do |format|
      if @beadfabrics.save #added plural to support array
        format.html { redirect_to(@beadfabric, :notice => 'Beadfabric was successfully created.') }
        format.xml  { render :xml => @beadfabric, :status => :created, :location => @beadfabric }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @beadfabric.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /beadfabrics/1
  # PUT /beadfabrics/1.xml
  def update
    @beadfabric = Beadfabric.find(params[:id])

    respond_to do |format|
      if @beadfabric.update_attributes(params[:beadfabric])
        format.html { redirect_to(@beadfabric, :notice => 'Beadfabric was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @beadfabric.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /beadfabrics/1
  # DELETE /beadfabrics/1.xml
  def destroy
    @beadfabric = Beadfabric.find(params[:id])
    @beadfabric.destroy

    respond_to do |format|
      format.html { redirect_to(beadfabrics_url) }
      format.xml  { head :ok }
    end
  end
end
