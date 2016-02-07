class JobPresenter < SimpleDelegator
  attr_reader :view, :model

  def initialize(model, view)
    @model = model
    @view = view
    super(@model)
  end
end
