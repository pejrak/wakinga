class BeadthreadsController < ApplicationController
before_filter :authenticate_user!
  # GET /beadthreads
  # GET /beadthreads.xml
  def index
    @beadthreads = Beadthread.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @beadthreads }
    end
  end

  # GET /beadthreads/1
  # GET /beadthreads/1.xml
  def show
    @beadthread = Beadthread.find(params[:id])
    @bead = Bead.all
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @beadthread }
    end
  end

  # GET /beadthreads/new
  # GET /beadthreads/new.xml
  def new
    @beadthread = Beadthread.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @beadthread }
    end
  end

  # GET /beadthreads/1/edit
  def edit
    @beadthread = Beadthread.find(params[:id])
  end

  # POST /beadthreads
  # POST /beadthreads.xml
  def create
    @beadthread = Beadthread.new(params[:beadthread])


    respond_to do |format|
      if @beadthread.save
        format.html { redirect_to(interests_path, :notice => 'Beadthread was successfully created.') }
        format.xml  { render :xml => @beadthread, :status => :created, :location => @beadthread }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @beadthread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /beadthreads/1
  # PUT /beadthreads/1.xml
  def update
    @beadthread = Beadthread.find(params[:id])

    respond_to do |format|
      if @beadthread.update_attributes(params[:beadthread])
        format.html { redirect_to(@beadthread, :notice => 'Beadthread was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @beadthread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /beadthreads/1
  # DELETE /beadthreads/1.xml
  def destroy
    @beadthread = Beadthread.find(params[:id])
    @beadthread.destroy

    respond_to do |format|
      format.html { redirect_to(beadthreads_url) }
      format.xml  { head :ok }
    end
  end
end
