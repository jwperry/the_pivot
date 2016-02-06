class User::JobsController < ApplicationController
  before_action :set_duration_tags, only: [:show]

  def show
    @user = User.find_by_slug(params[:user_slug])
    @job = Job.find(params[:id])
  end

  private

  def set_duration_tags
    @duration_tags = [
      ["Short (1 week or less)", 0],
      ["Medium (1 - 4 weeks)", 1],
      ["Long (Longer than 4 weeks)", 2],
      ["Event (Specific date & time)", 3]
    ]
  end
end
