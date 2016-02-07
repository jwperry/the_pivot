class JobPresenter < SimpleDelegator
  attr_reader :view, :model

  def initialize(model, view)
    @model = model
    @view = view
    super(@model)
  end

  def job_status_banner_or_bid_accordion
    if logged_in_user_has_bid_for_current_bidding_open_job
      view.render(partial: "user/jobs/my_bid_accordion",
                  locals: { job: self })
    elsif logged_in_user_can_place_a_bid_for_this_job
      view.render(partial: "user/jobs/place_a_bid_accordion",
                  locals: { job: self })
    elsif user_is_logged_out_but_bidding_is_open
      view.content_tag(:div,
                       view.link_to("Log In To Place A Bid", view.login_path),
                       class: "log-in-to-bid")
    elsif bidding_closed?
      view.content_tag(:div,
                       "Bidding Is Closed For This Job",
                       class: "bidding-closed")
    elsif in_progress?
      view.content_tag(:div,
                       "Job Is In Progress",
                       class: "job-in-progress")
    elsif completed?
      view.content_tag(:div,
                       "Job Completed",
                       class: "job-completed")
    elsif cancelled?
      view.content_tag(:div,
                       "Job Cancelled",
                       class: "job-cancelled")
    end
  end

  def current_bids_table
    if view.logged_in? && view.current_user_owns_current_job(id)
      view.render(partial: "user/jobs/current_bids_table",
                  locals: { job: self })
    end
  end

  private

  def user_is_logged_out_but_bidding_is_open
    view.logged_out? && bidding_open?
  end

  def logged_in_user_has_bid_for_current_bidding_open_job
    view.logged_in? && bids_include_user(view.current_user.id) && bidding_open?
  end

  def logged_in_user_can_place_a_bid_for_this_job
    view.logged_in? && view.current_user_does_not_own_job(id) && bidding_open?
  end
end
