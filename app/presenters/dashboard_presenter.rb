class DasboardPresenter
  attr_reader :model, :view, :user

  def initialize(model, view, user)
    @model = model
    @view = view
    @user = user
  end

  def action_link
    case model.status
    when "bidding open"
      view.link_to("Cancel", user_job_path(user, model, status: 4))
    when "bidding closed"
link_to "Mark as Paid", admin_order_path(order, status: 1), method: :put
    when "in progress"

    when "completed"

    when "cancelled"

    end
  end
end