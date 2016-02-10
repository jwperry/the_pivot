class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id

      if user.platform_admin?
        redirect_to session[:forwarding_url] || admin_dashboard_path
      else
        redirect_to session[:forwarding_url] || dashboard_path
      end
    else
      account_link = "#{view_context.link_to('Create new account?',
                                              new_user_path)}"
      flash[:error] = "Invalid login credentials. #{account_link}"
      redirect_to login_path
    end
  end

  # def create_from_linkedin
  #   # byebug
  #   auth_hash = request.env['omniauth.auth']
  #
  # @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
  # if @authorization
  #   session[:user_id] = @authorization.user.id
  #   redirect_to dashboard_path
  #   # render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
  # else
  #   # byebug
  #   first_name = auth_hash["info"]["name"].split[0]
  #   last_name = auth_hash["info"]["name"].split[1]
  #   @user = User.new :first_name => first_name, last_name: last_name
  #   @user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
  #   render "user/users/new"
  #
  #   # render :text => "Hi #{user.name}! You've signed up."
  # end
  # end

  def destroy
    session.clear
    redirect_to "/"
  end

  private

  def auth_hash
   request.env['omniauth.auth']
 end
end
