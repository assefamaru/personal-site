require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get teachings" do
    get :teachings
    assert_response :success
  end

  test "should get media" do
    get :media
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get youth-section" do
    get :youth-section
    assert_response :success
  end

end
