class NotificationMailer < ApplicationMailer
  def notify_bidder(bid)
    @bid = bid
    mail(to: bid.user.email_address, subject: notify_subject_line(bid))
  end

  def notify_subject_line(bid)
    if bid.accepted?
      "Your bid for #{bid.job.title} has been accepted!"
    else
      "Your bid for #{bid.job.title} has not succeeded."
    end
  end

  def feedback_prompt(job)
    @job = job
    contractor_email = job.contractor_for_selected_bid.email_address
    mail(to: contractor_email, subject: "Feedback Needed: #{job.title}")
  end
end
