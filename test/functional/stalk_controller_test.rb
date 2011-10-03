require 'test_helper'

class StalkControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get clear" do
    get :clear
    assert_response :success
  end

  test "should get search" do
    get :search
    assert_response :success
  end

end
