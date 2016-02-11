require "test_helper"

class GuestCanViewPaginatedCategoryShowTest < ActionDispatch::IntegrationTest
  test "guest can view paginated category show page" do
    category = Category.create(name: "Illusions")
    create_list(:job, 20, category_id: category.id)

    visit category_path(category)
    assert page.has_content?("← Previous 1 2 Next →")
  end
end
