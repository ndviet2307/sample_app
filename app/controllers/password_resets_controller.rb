class PasswordResetsController < ApplicationController
  before_action :get_user, :check_expiration, :valid_user, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t ".has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    redirect_to root_url unless @user&.activated?
    redirect_to root_url unless @user.authenticated? :reset, params[:id]
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".expired"
    redirect_to new_password_reset_url
  end
end
