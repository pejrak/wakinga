require 'test_helper'

class BeadfabricsControllerTest < ActionController::TestCase
  setup do
    @beadfabric = beadfabrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beadfabrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beadfabric" do
    assert_difference('Beadfabric.count') do
      post :create, :beadfabric => @beadfabric.attributes
    end

    assert_redirected_to beadfabric_path(assigns(:beadfabric))
  end

  test "should show beadfabric" do
    get :show, :id => @beadfabric.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @beadfabric.to_param
    assert_response :success
  end

  test "should update beadfabric" do
    put :update, :id => @beadfabric.to_param, :beadfabric => @beadfabric.attributes
    assert_redirected_to beadfabric_path(assigns(:beadfabric))
  end

  test "should destroy beadfabric" do
    assert_difference('Beadfabric.count', -1) do
      delete :destroy, :id => @beadfabric.to_param
    end

    assert_redirected_to beadfabrics_path
  end
end
