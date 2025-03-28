require "test_helper"

class TailHandlerControllerTest < ActionDispatch::IntegrationTest
  test "should get broadcast_logs" do
    get tail_handler_broadcast_logs_url
    assert_response :success
  end
end
