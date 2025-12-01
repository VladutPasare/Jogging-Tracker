class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: %i[show edit update destroy]

  before_action :require_manager_or_admin, only: [:index]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.all
  end

  def show
    unless current_user.admin? || current_user.manager? || current_user == @user
      redirect_to root_path, alert: "Acces interzis"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "Cont creat. Te poți autentifica."
    else
      render :new
    end
  end

  def edit
    unless current_user.admin? || current_user == @user
      redirect_to root_path, alert: "Acces interzis"
    end
  end

  def update
    unless current_user.admin? || current_user == @user
      redirect_to root_path, alert: "Acces interzis"
      return
    end

    if @user.update(user_params)
      redirect_to root_path, notice: "User modificat"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User șters"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
