class BeadsController < ApplicationController
before_filter :authenticate_admin!, :except => [:show, :index]
before_filter :authenticate_user!, :except => [:new, :edit, :create, :update, :destroy]

  def index
    if params[:interest_id]
      @interest = Interest.find(params[:interest_id])
    end
    @beads = Bead.search(params[:search]) - @interest.beads
    @nouns = Noun.search(params[:search])
    respond_to do |format|

      format.html
      format.js
      format.xml  { render :xml => @beads }
    end
  end


  def show
    @bead = Bead.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @bead }
    end
  end


  def new
    @bead = Bead.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @bead }
    end
  end


  def edit
    @bead = Bead.find(params[:id])
  end


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


  def destroy
    @bead = Bead.find(params[:id])
    @bead.destroy

    respond_to do |format|
      format.html { redirect_to(beads_url) }
      format.xml  { head :ok }
    end
  end
end
