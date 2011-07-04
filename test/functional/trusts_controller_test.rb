require 'test_helper'

class TrustsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Trust.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Trust.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Trust.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to trust_url(assigns(:trust))
  end

  def test_edit
    get :edit, :id => Trust.first
    assert_template 'edit'
  end

  def test_update_invalid
    Trust.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Trust.first
    assert_template 'edit'
  end

  def test_update_valid
    Trust.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Trust.first
    assert_redirected_to trust_url(assigns(:trust))
  end

  def test_destroy
    trust = Trust.first
    delete :destroy, :id => trust
    assert_redirected_to trusts_url
    assert !Trust.exists?(trust.id)
  end
end
