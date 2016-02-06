FactoryGirl.define do
  factory :category do
    name
    description "Awesome Category"
  end

  factory :bid do
    price
    duration_estimate 24
    details "Bid details are amaze balls"
    status "pending"
  end

  factory :comment do
    association :user, factory: :contractor
    recipient
    text Faker::Lorem.characters(60)
    rating
    job
  end

  factory :job do
    title
    description "Job description"
    status 0
    city "Denver"
    state "CO"
    zipcode 802_31
    bidding_close_date
    must_complete_by_date
    category
    association :user, factory: :lister
    duration_estimate 1

    factory :job_posted_by_platform_admin do
      association :user, factory: :platform_admin
    end
  end

  factory :contractor, class: User do
    first_name
    last_name
    username
    password "password"
    role 0
    email_address
    street_address "123 Maple Drive"
    city "Denver"
    state "CO"
    zipcode 802_31
    bio "This sure is a sweet bio"

    factory :lister, aliases: [:recipient] do
      role 1
    end

    factory :platform_admin do
      username "platform_admin"
      role 2
    end
  end

  sequence :bidding_close_date do |n|
    Time.now + n.hours
  end

  sequence :must_complete_by_date do |n|
    Time.now + n.days
  end

  sequence :rating, [1, 2, 3, 4, 5].cycle do |n|
    n
  end

  sequence :price do |n|
    n * 100
  end

  sequence :name, %w(a b c d e f g h i).cycle do |n|
    "name#{n}"
  end

  sequence :email_address do |n|
    "example#{n}@gmail.com"
  end

  sequence :first_name do |n|
    "firstname#{n}"
  end

  sequence :last_name do |n|
    "lastname#{n}"
  end

  sequence :title do |n|
    "title#{n}"
  end

  sequence :username do |n|
    "username#{n}"
  end
end
