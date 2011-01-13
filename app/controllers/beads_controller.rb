class BeadsController < ApplicationController
before_filter :authenticate_user!
  # GET /beads
  # GET /beads.xml
  def index
    @beads = Bead.search(params[:search])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @beads }
    end
  end

  # GET /beads/1
  # GET /beads/1.xml
  def show
    @bead = Bead.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bead }
    end
  end

  # GET /beads/new
  # GET /beads/new.xml
  def new
    @bead = Bead.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bead }
    end
  end

  # GET /beads/1/edit
  def edit
    @bead = Bead.find(params[:id])
  end

  # POST /beads
  # POST /beads.xml
  def create
    @bead = Bead.new(params[:bead])

    respond_to do |format|
      if @bead.save
        format.html { redirect_to(@bead, :notice => 'bead was successfully created.') }
        format.xml  { render :xml => @bead, :status => :created, :location => @bead }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bead.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /beads/1
  # PUT /beads/1.xml
  def update
    @bead = Bead.find(params[:id])

    respond_to do |format|
      if @bead.update_attributes(params[:bead])
        format.html { redirect_to(@bead, :notice => 'bead was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bead.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /beads/1
  # DELETE /beads/1.xml
  def destroy
    @bead = Bead.find(params[:id])
    @bead.destroy

    respond_to do |format|
      format.html { redirect_to(beads_url) }
      format.xml  { head :ok }
    end
  end
end
