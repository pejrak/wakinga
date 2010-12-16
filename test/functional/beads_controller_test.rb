require 'test_helper'

class BeadsControllerTest < ActionController::TestCase
  setup do
    @bead = beads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bead" do
    assert_difference('bead.count') do
      post :create, :bead => @bead.attributes
    end

    assert_redirected_to bead_path(assigns(:bead))
  end

  test "should show bead" do
    get :show, :id => @bead.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @bead.to_param
    assert_response :success
  end

  test "should update bead" do
    put :update, :id => @bead.to_param, :bead => @bead.attributes
    assert_redirected_to bead_path(assigns(:bead))
  end

  test "should destroy bead" do
    assert_difference('bead.count', -1) do
      delete :destroy, :id => @bead.to_param
    end

    assert_redirected_to beads_path
  end
end
