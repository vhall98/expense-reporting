class SessionsController < ApplicationController
  before_action :authenticate_user, :only => [:home, :profile, :setting]
  before_action :save_login_state, :only => [:login, :login_attempt]
  
  def login
  #Login Form
  render "login"
  end
  
  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:login_password])
    if !authorized_user.nil?
      session[:user_id] = authorized_user.id
      # flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
      # redirect_to(:action => 'home')
      redirect_to expenses_path
    else
      flash[:notice_b] = "Invalid Username or Password"
      # flash[:color]= "invalid"
      # render "login"
      redirect_to :action => 'login'
    end
  end
  
  def logout
    session[:user_id] = nil
    # redirect_to :action => 'login'
    redirect_to sessions_login_path
  end
  
  def home
  end

  def profile
  end

  def setting
  end
end
