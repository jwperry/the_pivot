FactoryGirl.define do
  factory :category do
    name
  end

  factory :bid do
    price
    duration_estimate 3
    details Faker::Lorem.sentence(20)
    status "pending"
    association :user, factory: :contractor
    job

    factory :bid_placed_by_job_lister do
      association :user, factory: :lister
    end

    factory :bid_placed_by_platform_admin do
      association :user, factory: :platform_admin
    end
  end

  factory :comment do
    association :user, factory: :contractor
    recipient
    text Faker::Lorem.sentence(20)
    rating
    job
  end

  factory :job do
    title
    description Faker::Lorem.sentence(20)
    status 0
    city "Denver"
    state "CO"
    zipcode "80231"
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
    zipcode "80231"
    bio "This sure is a sweet bio that has at least 35 characters"

    factory :lister, aliases: [:recipient] do
      username
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
