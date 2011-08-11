require 'test_helper'

class UserPreferencesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => UserPreference.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    UserPreference.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    UserPreference.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to user_preference_url(assigns(:user_preference))
  end

  def test_edit
    get :edit, :id => UserPreference.first
    assert_template 'edit'
  end

  def test_update_invalid
    UserPreference.any_instance.stubs(:valid?).returns(false)
    put :update, :id => UserPreference.first
    assert_template 'edit'
  end

  def test_update_valid
    UserPreference.any_instance.stubs(:valid?).returns(true)
    put :update, :id => UserPreference.first
    assert_redirected_to user_preference_url(assigns(:user_preference))
  end

  def test_destroy
    user_preference = UserPreference.first
    delete :destroy, :id => user_preference
    assert_redirected_to user_preferences_url
    assert !UserPreference.exists?(user_preference.id)
  end
end
