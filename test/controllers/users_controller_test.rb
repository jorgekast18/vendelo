require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:paco)

    test "should get show" do
      get user_path(@user.username)
      assert_response :success
    end
  end
end
