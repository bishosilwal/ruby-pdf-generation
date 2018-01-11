require 'test_helper'

class FolderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get folder_index_url
    assert_response :success
  end

  test "should get create" do
    get folder_create_url
    assert_response :success
  end

  test "should get delete" do
    get folder_delete_url
    assert_response :success
  end

  test "should get show" do
    get folder_show_url
    assert_response :success
  end

  test "should get edit" do
    get folder_edit_url
    assert_response :success
  end

end
