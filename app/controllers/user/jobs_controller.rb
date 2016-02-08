class User::JobsController < ApplicationController
  def show
    session[:forwarding_url] = request.url

    @user = User.find_by_slug(params[:user_slug])
    @job = JobPresenter.new(Job.find(params[:id]), view_context)
  end
end
