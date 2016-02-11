class User::CommentsController < ApplicationController
  before_action :update_params, only: [:create]
  before_action :require_lister_or_contractor
  before_action :feedback_is_not_duplicate

  def new
    @user = current_user
    @job = Job.find(params[:job_id])
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      flash[:success] = "Comment Saved!"
      @comment.job.update_attribute(:status, 3) unless current_contractor?
      redirect_to dashboard_path
    else
      flash[:error] = "Comment could not be saved."
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:rating,
                                    :text,
                                    :job_id,
                                    :recipient_id)
  end

  def update_params
    params[:comment][:rating] = params[:comment][:rating].to_i
    params[:comment][:job_id] = params[:job_id]
    params[:comment][:recipient_id] = find_recipient_id
  end

  def find_recipient_id
    job = Job.find(params[:job_id])

    if job.lister == current_user
      job.contractor_for_selected_bid.id
    else
      job.lister.id
    end
  end

  def require_lister_or_contractor
    render file: "public/404" unless correct_lister || correct_contractor
  end

  def correct_lister
    current_user == Job.find(params[:job_id]).lister
  end

  def correct_contractor
    current_user == Job.find(params[:job_id]).contractor_for_selected_bid
  end

  def feedback_is_not_duplicate
    job = Job.find(params[:job_id])
    previous_comment = job.comments.where(user_id: current_user.id)
    render file: "public/404" unless previous_comment.empty?
  end
end
