require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, {}, :user_id => "1"  # sets the session cookie; session[:user_id]
    assert_response :success
  end

end
