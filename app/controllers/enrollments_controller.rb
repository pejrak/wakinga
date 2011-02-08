class EnrollmentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create]
  def index
    @enrollments = Enrollment.all
  end

  def show
    @enrollment = Enrollment.find(params[:id])
  end

  def new
    @enrollment = Enrollment.new
  end

  def create
    einstein_check = params[:enrollment][:ein]
    if einstein_check == "March" then
      @enrollment = Enrollment.new(params[:enrollment])
      if @enrollment.save
        flash[:notice] = @enrollment.email + " has been recorded."
        redirect_to @enrollment
      else
        render :action => 'new'
      end
    else flash[:notice] = "Try thinking about this."
      redirect_to new_enrollment_path
    end
  end

  def edit
    @enrollment = Enrollment.find(params[:id])
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    if @enrollment.update_attributes(params[:enrollment])
      flash[:notice] = "Successfully updated enrollment."
      redirect_to enrollment_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @enrollment = Enrollment.find(params[:id])
    @enrollment.destroy
    flash[:notice] = "Successfully destroyed enrollment."
    redirect_to enrollments_url
  end
end
