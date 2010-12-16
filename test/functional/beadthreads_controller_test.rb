require 'test_helper'

class BeadthreadsControllerTest < ActionController::TestCase
  setup do
    @beadthread = beadthreads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beadthreads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beadthread" do
    assert_difference('Beadthread.count') do
      post :create, :beadthread => @beadthread.attributes
    end

    assert_redirected_to beadthread_path(assigns(:beadthread))
  end

  test "should show beadthread" do
    get :show, :id => @beadthread.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @beadthread.to_param
    assert_response :success
  end

  test "should update beadthread" do
    put :update, :id => @beadthread.to_param, :beadthread => @beadthread.attributes
    assert_redirected_to beadthread_path(assigns(:beadthread))
  end

  test "should destroy beadthread" do
    assert_difference('Beadthread.count', -1) do
      delete :destroy, :id => @beadthread.to_param
    end

    assert_redirected_to beadthreads_path
  end
end
