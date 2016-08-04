require 'test_helper'

class ObservationControllerTest < ActionController::TestCase
  test "should get Index" do
    get :Index
    assert_response :success
  end

  test "should get Create" do
    get :Create
    assert_response :success
  end

end
