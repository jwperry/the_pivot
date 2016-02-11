class CategoryPresenter < SimpleDelegator
  attr_reader :view, :category, :categories, :jobs

  def initialize(category, jobs, categories, view)
    @view = view
    @category = category
    @jobs = jobs
    @categories = categories
    super(@category)
  end
end
