require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should create user and employee" do
    assert_difference('User.count') do
      post :create, :user => {:username => 'marvin', :email => 'marvin@css.com', :password => "askforit", :password_confirmation => "askforit"}
    end
    assert_difference('Employee.count') do
      post :create, :user => {:username => 'jacob', :email => 'jacob@css.com', :password => "askforit", :password_confirmation => "askforit"}
    end
    # assert_redirected_to review_path(assigns(:review))
  end
 end
