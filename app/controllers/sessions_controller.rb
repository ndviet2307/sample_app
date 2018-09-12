class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        login_with_remember user
      else
        flash[:warning] = t ".not_activated"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".invalid_email_or_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t "user.alert.success.logout"
    redirect_to root_url
  end

  private

  def login_with_remember user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    flash[:success] = t "user.alert.success.login"
    redirect_back_or user
  end
end
