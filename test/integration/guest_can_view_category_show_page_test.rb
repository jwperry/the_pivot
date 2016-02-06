require "test_helper"

class GuestCanViewCategoryShowPage < ActionDispatch::IntegrationTest
  test "guest can view category show page" do
    job = create(:job)
    visit "/categories/#{job.category.name}"
    assert page.has_content?(job.category.name)
    assert page.has_content?(job.title)
    assert page.has_content?(job.description)
    assert page.has_content?(job.duration_estimate)
    assert page.has_content?(job.user.first_name)
    assert page.has_content?(job.user.last_name)
    assert page.has_content?(job.user.file_upload_file_name)
    assert page.has_content?(job.bids.count)
    assert page.has_content?(job.city)
    assert page.has_content?(job.state)
    assert page.has_content?(job.lowest_bid)
    assert page.has_content?(job.highest_bid)
    assert page.has_content?(job.bidding_closes_on)
  end

  test "category show page only shows jobs with bidding_open status" do
    category = create(:category)
    job0 = create(:job, category: category)
    job1 = create(:job, category: category, status: 1)
    job2 = create(:job, category: category, status: 2)
    job3 = create(:job, category: category, status: 3)
    job4 = create(:job, category: category, status: 4)
    visit "/categories/#{job1.category.name}"
    assert page.has_content?(job0.title)
    refute page.has_content?(job1.title)
    refute page.has_content?(job2.title)
    refute page.has_content?(job3.title)
    refute page.has_content?(job4.title)
  end

end