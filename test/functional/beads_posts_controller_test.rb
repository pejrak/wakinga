require 'test_helper'

class BeadsPostsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BeadsPost.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BeadsPost.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BeadsPost.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to beads_post_url(assigns(:beads_post))
  end

  def test_edit
    get :edit, :id => BeadsPost.first
    assert_template 'edit'
  end

  def test_update_invalid
    BeadsPost.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BeadsPost.first
    assert_template 'edit'
  end

  def test_update_valid
    BeadsPost.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BeadsPost.first
    assert_redirected_to beads_post_url(assigns(:beads_post))
  end

  def test_destroy
    beads_post = BeadsPost.first
    delete :destroy, :id => beads_post
    assert_redirected_to beads_posts_url
    assert !BeadsPost.exists?(beads_post.id)
  end
end
