require "test_helper"

class PassthroughControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get passthrough_index_url
    assert_response :success
  end
end
