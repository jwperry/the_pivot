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
      create_authorization_when_from_linkedin
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
      redirect_to dashboard_path
    else
      flash.now[:error] = "Incorrect user information"
      render :edit
    end
  end

  def dashboard
    user = current_user
    @user = DashboardPresenter.new(user, view_context)
  end

  def linkedin
    @auth = Authorization.find_by_provider_and_uid(auth_hash["provider"],
                                                   auth_hash["uid"])
    if @auth
      session[:user_id] = @auth.user.id
      redirect_to dashboard_path
    else
      @user = User.new
      creator = LinkedInUserCreator.new(@user, auth_hash)
      creator.update_user
      @provider = auth_hash["provider"]
      @uid = auth_hash["uid"]
      render :new
    end
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
                                 :bio,
                                 :image_path)
  end

  def user_slug_is_current_user
    current_user.slug == params[:slug]
  end

  def require_logged_in_user
    flash[:error] = "Must be logged in to view user profiles"
    redirect_to login_path unless logged_in?
  end

  def auth_hash
    request.env["omniauth.auth"]
  end

  def create_authorization_when_from_linkedin
    if params["provider"] && params["uid"]
      @user.authorizations.create provider: params["provider"],
                                  uid: params["uid"]
    end
  end
end
