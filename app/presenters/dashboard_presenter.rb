class DashboardPresenter < SimpleDelegator
  attr_reader :view, :model

  def initialize(model, view)
    @view = view
    @model = model
    super(@model)
  end

  def action_link(job)
    case job.status
    when "bidding_open"
      cancel_link(job)
    when "bidding_closed"
      choose_bid_link(job) + " / " + cancel_link(job)
    when "in_progress"
      complete_link(job)
    when "completed"
      "N/A"
    when "cancelled"
      "N/A"
    end
  end

  def choose_bid_link(job)
    view.link_to("Choose Bid", view.user_job_path(model, job))
  end

  def cancel_link(job)
    view.link_to("Cancel", view.user_job_path(model, job, status: 4), method: :put)
  end

  def complete_link(job)
    view.link_to("Complete", view.user_job_path(model, job, status: 3), method: :put)
  end

  def sanitize_status(job)
    job.status.gsub("_", " ")

  end

  def chosen_contractor(job)
    if !job.bids.accepted.empty?
      job.bids.accepted.first.user.full_name
    else
      ""
    end
  end
end
