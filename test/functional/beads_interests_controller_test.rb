require 'test_helper'

class BeadsInterestsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BeadsInterest.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BeadsInterest.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BeadsInterest.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to beads_interest_url(assigns(:beads_interest))
  end

  def test_edit
    get :edit, :id => BeadsInterest.first
    assert_template 'edit'
  end

  def test_update_invalid
    BeadsInterest.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BeadsInterest.first
    assert_template 'edit'
  end

  def test_update_valid
    BeadsInterest.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BeadsInterest.first
    assert_redirected_to beads_interest_url(assigns(:beads_interest))
  end

  def test_destroy
    beads_interest = BeadsInterest.first
    delete :destroy, :id => beads_interest
    assert_redirected_to beads_interests_url
    assert !BeadsInterest.exists?(beads_interest.id)
  end
end
