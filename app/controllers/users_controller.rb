class UsersController < ApplicationController
  require "states_helper"
  before_action :set_user, only: [:edit, :update]

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
      if current_user.admin?
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
                                 :file_upload)
  end

  def user_slug_is_current_user
    current_user.slug == params[:slug]
  end
end
