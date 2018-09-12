class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, only: %i(show edit update destroy)

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "sessions.create.please_check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    redirect_to signup_path unless @user
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "user.alert.success.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "user.alert.success.delete"
    redirect_to users_url
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "user.alert.error.login"
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    redirect_to login_url unless (@user = User.find_by id: params[:id])
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
