class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def authenticate_user
    if session[:user_id]
      # set current user object to @current_user object variable
      
      if User.nil?
        redirect_to logout_path
        return false
      end
      @current_user = User.find session[:user_id]

      @db_cols = ExpenseReporting::Application.config.db_columns
      @user = Employee.where("#{@db_cols[:employeeid]} = ?", @current_user["#{@db_cols[:username]}"]).first

      if @user.nil?
        redirect_to logout_path
        return false
      end

      return true
    else
      redirect_to(:controller => 'sessions', :action => 'login')
      return false
    end
  end

  def save_login_state
    if session[:user_id].nil?
      return false
    end    
    
    if session[:user_id]
      redirect_to expenses_path
      return false
    end
    return true
  end
end
