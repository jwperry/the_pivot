require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  test "notify_bidders sends correct emails to winning and losing bidders" do
    job = create(:job)
    winning_bid = create(:bid, status: 1)
    losing_bid = create(:bid, status: 2)
    job.bids << winning_bid
    job.bids << losing_bid
    job.bids.each do |bid|
      NotificationMailer.notify_bidder(bid).deliver_later
    end

    assert_equal 2, ActionMailer::Base.deliveries.count
    winning_email = ActionMailer::Base.deliveries.first
    losing_email = ActionMailer::Base.deliveries.last
    bid_end_message   = "Bidding on the job #{job.title} has now concluded."
    success_message   = "Congratulations, your bid was successful! Please "\
                        "contact the job lister to make arrangements."
    rejection_message = "Thank you for your interest! Your bid was not "\
                        "successful, but many more jobs await your talents!"

    assert_equal "Your bid for #{job.title} has been accepted!",
                 winning_email.subject
    assert_equal ["#{winning_bid.user.email_address}"], winning_email.to
    assert_equal ["no-reply@freelancerforyou.com"], winning_email.from
    assert winning_email.body.encoded.include?(bid_end_message)
    assert winning_email.body.encoded.include?(success_message)
    refute winning_email.body.encoded.include?(rejection_message)

    assert_equal "Your bid for #{job.title} has not succeeded.",
                 losing_email.subject
    assert_equal ["#{losing_bid.user.email_address}"], losing_email.to
    assert_equal ["no-reply@freelancerforyou.com"], losing_email.from
    assert losing_email.body.encoded.include?(bid_end_message)
    refute losing_email.body.encoded.include?(success_message)
    assert losing_email.body.encoded.include?(rejection_message)
  end

  test "feedback_prompt sends correct email only to job's winning contractor" do
    job = create(:job)
    winning_bid = create(:bid, status: 1)
    losing_bid = create(:bid, status: 2)
    job.bids << winning_bid
    job.bids << losing_bid
    NotificationMailer.feedback_prompt(job).deliver_later

    assert_equal 1, ActionMailer::Base.deliveries.count
    email = ActionMailer::Base.deliveries.first
    complete_message   = "The job #{job.title} has been marked as complete "\
                         "by the lister. Well done!"
    feedback_message   = "Please log into your account to leave feedback."

    assert_equal "Feedback Needed: #{job.title}", email.subject
    assert_equal ["#{winning_bid.user.email_address}"], email.to
    assert_equal ["no-reply@freelancerforyou.com"], email.from
    assert email.body.encoded.include?(complete_message)
    assert email.body.encoded.include?(feedback_message)
  end
end
