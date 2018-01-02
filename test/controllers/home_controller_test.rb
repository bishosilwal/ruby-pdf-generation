require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get show" do
    get home_show_url
    assert_response :success
  end

  test "should get new" do
    get home_new_url
    assert_response :success
  end

  test "should get create" do
    get home_create_url
    assert_response :success
  end

  test "should get destroy" do
    get home_destroy_url
    assert_response :success
  end

end
