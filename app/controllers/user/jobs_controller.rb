class User::JobsController < ApplicationController
  def show
    @user = User.find_by_slug(params[:user_slug])
    @job = JobPresenter.new(Job.find(params[:id]), view_context)
  end
end
