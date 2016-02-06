class User::JobsController < ApplicationController
  def show
    @user = User.find_by_slug(params[:user_slug])
    @job = Job.find(params[:id])
  end
end
