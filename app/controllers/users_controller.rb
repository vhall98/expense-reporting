class UsersController < ApplicationController
  before_filter :save_login_state, :only => [:new, :create]
  before_filter :save_login_state, :only => [:create]
  
  def new
    @user = User.new
  end
  def create
    @db_cols = ExpenseReporting::Application.config.db_columns
    @user = User.new(params[:user])
    @employee = Employee.new
    @employee[@db_cols[:employeeid]] = @user[@db_cols[:username]]
    @employee[@db_cols[:reviewerid]] = Sys::Admin.get_login
    
    if @user.save && @employee.save
      flash[:notice_a] = "You signed up successfully. Proceed to log in to your account"
      # flash[:color] = "valid"
    else
      # flash[:notice] = "Form is invalid"
      # flash[:color]= "invalid"
    end
    # render "new"
    # redirect_to sessions_login_path
    render 'sessions/login'
  end
end
