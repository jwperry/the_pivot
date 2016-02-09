class Seed
  def self.start
    new.generate
  end

  def generate
    create_categories
    create_turing_contractors
    create_contractors
    create_job_listers
    create_turing_job_lister
    create_job_listings
    create_contractor_bids
    create_comments
    create_platform_admin
  end

  def create_categories
    categories = ["Carpentry",
                  "Photography",
                  "Web Design",
                  "Electrical",
                  "Landscaping",
                  "Writing",
                  "Catering",
                  "Marketing",
                  "Business Services",
                  "Housework"]

    categories.each do |name|
      Category.create!(name: name)

      puts "Created category: #{name}"
    end
  end

  def create_turing_contractors
    users = ["Joseph Perry",
             "Dan Winter",
             "Toni Rib",
             "Josh Mejia"]

    users.each do |full_name|
      first_name = full_name.split.first
      last_name = full_name.split.last

      User.create!(
        first_name: first_name,
        last_name: last_name,
        username: "#{first_name.downcase}_user",
        password: "password",
        role: 0,
        email_address: "#{first_name.downcase}@turing.io",
        street_address: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip,
        bio: Faker::Lorem.sentence(20)
      )

      puts "Created Turing Contractor: #{full_name}"
    end
  end

  def create_contractors
    100.times do |i|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name

      User.create!(
        first_name: first_name,
        last_name: last_name,
        username: "#{first_name.downcase}#{i}",
        password: "password",
        role: 0,
        email_address: "#{first_name.downcase}#{i}@example.com",
        street_address: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip,
        bio: Faker::Lorem.sentence(20)
      )

      puts "Created Contractor: #{first_name} #{last_name}"
    end
  end

  def create_job_listers
    20.times do |i|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name

      User.create!(
        first_name: first_name,
        last_name: last_name,
        username: "#{first_name.downcase}#{i}_joblister",
        password: "password",
        role: 1,
        email_address: "#{first_name.downcase}#{i}_joblister@example.com",
        street_address: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip,
        bio: Faker::Lorem.sentence(20)
      )

      puts "Created Job Lister: #{first_name} #{last_name}"
    end
  end

  def create_turing_job_lister
    first_name = "Andrew"
    last_name = "Carmer"

    User.create!(
      first_name: first_name,
      last_name: last_name,
      username: "#{first_name.downcase}_user",
      password: "password",
      role: 1,
      email_address: "#{first_name.downcase}@turing.io",
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      zipcode: Faker::Address.zip,
      bio: Faker::Lorem.sentence(20)
    )

    puts "Created Turing Job Lister: #{first_name} #{last_name}"
  end

  def create_job_listings
    User.listers.each do |job_lister|
      5.times do
        job_lister.jobs.create!(
          title: Faker::Commerce.product_name,
          category_id: rand(1..10),
          description: Faker::Lorem.paragraph(6),
          status: rand(0..4),
          city: Faker::Address.city,
          state: Faker::Address.state_abbr,
          zipcode: Faker::Address.zip,
          bidding_close_date: Faker::Time.forward(14, :morning),
          must_complete_by_date: Faker::Time.between(DateTime.now + 15,
                                                     DateTime.now + 21),
          duration_estimate: rand(0..3)
        )

        puts "Created Job Listing: #{Job.last.title} for #{Job.last.user.full_name}"
      end
    end
  end

  def create_contractor_bids
    User.contractors.each do |contractor|
      10.times do |i|
        contractor.bids.create!(
          job_id: rand(1..100),
          price: (i + 1) * rand(1..100),
          duration_estimate: rand(1..60),
          details: Faker::Lorem.sentence(10),
          status: 0
        )

        puts "Created Bid by #{contractor.full_name} on job #{Bid.last.job.title}"
      end
    end

    update_bid_status
    update_job_status
  end

  def update_bid_status
    Job.bid_selected.each do |job|
      next if job.bids.empty?

      job.bids.each_with_index do |bid, index|
        if index.zero?
          bid.update_attribute(:status, 1)
        else
          bid.update_attribute(:status, 2)
        end
      end

      puts "Contractor #{job.bids.accepted.first.user.full_name} won job #{job.title}"
    end
  end

  def update_job_status
    Job.bid_selected.each do |job|
      next unless job.bids.empty?

      job.update_attribute(:status, "cancelled")
    end
  end

  def create_comments
    Job.completed.each do |job|
      job.comments.create!(
        user_id: job.lister.id,
        recipient_id: job.bids.accepted.first.user.id,
        text: Faker::Lorem.sentence(15),
        rating: rand(1..5)
      )

      job.comments.create!(
        user_id: job.bids.accepted.first.user.id,
        recipient_id: job.lister.id,
        text: Faker::Lorem.sentence(15),
        rating: rand(1..5)
      )

      puts "Comments created for job: #{job.title}"
    end
  end

  def create_platform_admin
    User.create!(
      first_name: "Platform",
      last_name: "Admin",
      username: "platform_admin",
      password: "password",
      role: 2,
      email_address: "platform_admin@turing.io",
      street_address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      zipcode: Faker::Address.zip,
      bio: Faker::Lorem.sentence(20)
    )

    puts "Created Platform Admin"
  end
end

Seed.start
