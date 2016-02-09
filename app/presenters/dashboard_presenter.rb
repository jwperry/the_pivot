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
    end
  end

  def choose_bid_link(job)
    view.link_to("Choose Bid", view.user_job_path(model, job))
  end

  def cancel_link(job)
    view.link_to("Cancel", view.user_job_path(model, job, status: 4),
                 method: :put)
  end

  def complete_link(job)
    view.link_to("Complete", view.user_job_path(model, job, status: 3),
                 method: :put)
  end

  def sanitize_status(job)
    job.status.tr("_", " ")
  end

  def chosen_contractor(job)
    if !job.bids.accepted.empty?
      job.bids.accepted.first.user.full_name
    end
  end

  def display_bids_table
    if has_bids?
      view.render partial: "bid_table", locals: { user: self }
    else
      view.content_tag(:div,
                       view.content_tag(:p,
                                        "You have not bid on any jobs yet.",
                                        class: "no-bids"))
    end
  end

  def display_listing_table
    if not_contractor_and_has_jobs
      view.render partial: "listing_table", locals: { user: self }
    elsif not_contractor_and_does_not_have_jobs
      view.content_tag(:div,
                       view.content_tag(:p,
                                        "You have not listed any jobs yet.",
                                        class: "no-listings"))
    end
  end

  def not_contractor_and_has_jobs
    !view.current_contractor? && has_jobs?
  end

  def not_contractor_and_does_not_have_jobs
    !view.current_contractor? && !has_jobs?
  end

  def dashboard_links
    if view.current_platform_admin?
      view.render partial: "admin_dashboard_links", locals: { user: self }
    elsif view.current_lister?
      view.render partial: "lister_dashboard_links", locals: { user: self }
    else
      view.render partial: "contractor_dashboard_links", locals: { user: self }
    end
  end

  def listings_tab_header
    unless view.current_contractor?
      view.content_tag(:li,
                       view.link_to("My Listings", "#my-listings"),
                       class: "tab col s3")
    end
  end
end
