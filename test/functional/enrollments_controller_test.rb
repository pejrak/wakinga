require 'test_helper'

class EnrollmentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Enrollment.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Enrollment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Enrollment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to enrollment_url(assigns(:enrollment))
  end

  def test_edit
    get :edit, :id => Enrollment.first
    assert_template 'edit'
  end

  def test_update_invalid
    Enrollment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Enrollment.first
    assert_template 'edit'
  end

  def test_update_valid
    Enrollment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Enrollment.first
    assert_redirected_to enrollment_url(assigns(:enrollment))
  end

  def test_destroy
    enrollment = Enrollment.first
    delete :destroy, :id => enrollment
    assert_redirected_to enrollments_url
    assert !Enrollment.exists?(enrollment.id)
  end
end
