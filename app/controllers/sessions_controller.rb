class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      flash[:success] = t "user.alert.success.login"
      redirect_to user
    else
      flash.now[:danger] = t ".invalid_email_or_password"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t "user.alert.success.logout"
    redirect_to root_url
  end
end
