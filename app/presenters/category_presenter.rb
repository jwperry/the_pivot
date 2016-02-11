class CategoryPresenter < SimpleDelegator
  attr_reader :view, :category, :categories, :jobs

  def initialize(category, jobs, categories, view)
    @view = view
    @category = category
    @jobs = jobs
    @categories = categories
    super(@category)
  end

  def show_jobs
    if jobs_open_for_bidding.empty?
      view.content_tag(:h5, "No Jobs Open For Bidding In This Category")
    else
      view.render partial: "category_jobs", locals: { category: self }
    end
  end
end
