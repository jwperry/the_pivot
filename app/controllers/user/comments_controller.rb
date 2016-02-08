class User::CommentsController < ApplicationController
  def new
    @user = current_user
    @job = Job.find(params[:job_id])
    @comment = Comment.new
  end

  def create
  end
end
