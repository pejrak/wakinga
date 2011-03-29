require 'test_helper'

class MemorizationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Memorization.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Memorization.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Memorization.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to memorization_url(assigns(:memorization))
  end

  def test_edit
    get :edit, :id => Memorization.first
    assert_template 'edit'
  end

  def test_update_invalid
    Memorization.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Memorization.first
    assert_template 'edit'
  end

  def test_update_valid
    Memorization.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Memorization.first
    assert_redirected_to memorization_url(assigns(:memorization))
  end

  def test_destroy
    memorization = Memorization.first
    delete :destroy, :id => memorization
    assert_redirected_to memorizations_url
    assert !Memorization.exists?(memorization.id)
  end
end
