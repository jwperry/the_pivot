class User::UsersController < ApplicationController
  require "states_helper"
  before_action :set_user, only: [:edit, :update]
  before_action :require_logged_in_user, only: [:show, :dashboard]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def show
    @user = User.find_by_slug(params[:slug])
  end

  def edit
    render file: "public/404" unless user_slug_is_current_user
  end

  def update
    if @user.update_attributes(user_params)
      if current_user.platform_admin?
        redirect_to admin_dashboard_path
      else
        redirect_to dashboard_path
      end
    else
      flash.now[:error] = "Incorrect user information"
      render :edit
    end
  end

  def dashboard
    user = current_user
    @user = DashboardPresenter.new(user, view_context)
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :username,
                                 :password,
                                 :password_confirmation,
                                 :email_address,
                                 :street_address,
                                 :city,
                                 :state,
                                 :zipcode,
                                 :role,
                                 :slug,
                                 :file_upload,
                                 :bio)
  end

  def user_slug_is_current_user
    current_user.slug == params[:slug]
  end

  def require_logged_in_user
    redirect_to login_path unless logged_in?
  end
end
