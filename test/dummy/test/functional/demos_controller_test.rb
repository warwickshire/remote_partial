require 'test_helper'

class DemosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: 'fixed'
    assert_response :success
  end

end
