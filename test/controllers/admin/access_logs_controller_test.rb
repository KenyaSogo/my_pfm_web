require 'test_helper'

class Admin::AccessLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_access_logs_index_url
    assert_response :success
  end

end
