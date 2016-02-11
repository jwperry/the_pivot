require "test_helper"

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:username)
  should validate_uniqueness_of(:username)
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email_address)
  should validate_presence_of(:street_address)
  should validate_presence_of(:city)
  should validate_presence_of(:state)
  should validate_presence_of(:zipcode)
  should validate_presence_of(:bio)
  should validate_numericality_of(:zipcode)
  should validate_length_of(:zipcode).is_equal_to(5)

  test "full address" do
    street_address = "1510 Blake St."
    city = "Denver"
    state = "CO"
    zipcode = "80223"
    contractor = create(:contractor,
                        street_address: street_address,
                        city:           city,
                        state:          state,
                        zipcode:        zipcode)

    assert_equal "1510 Blake St. Denver, CO 80223", contractor.full_address
  end

  test "full name" do
    contractor = create(:contractor,
                        first_name: "Job",
                        last_name: "Bluth")

    assert_equal "Job Bluth", contractor.full_name
  end

  test "has bids" do
    contractor = create(:contractor)

    refute contractor.has_bids?

    create(:bid, user_id: contractor.id)

    assert contractor.has_bids?
  end

  test "has jobs" do
    lister = create(:lister)

    refute lister.has_jobs?

    create(:job, user_id: lister.id)

    assert lister.has_jobs?
  end

  test "is invalid with bio less than 35 characters" do
    user = create(:contractor)

    user.update_attribute(:bio, Faker::Lorem.characters(35))
    assert user.valid?

    user.update_attribute(:bio, Faker::Lorem.characters(34))
    refute user.valid?
  end

  test "is invalid with bio greater than 600 characters" do
    user = create(:contractor)

    user.update_attribute(:bio, Faker::Lorem.characters(600))
    assert user.valid?

    user.update_attribute(:bio, Faker::Lorem.characters(601))
    refute user.valid?
  end

  test "email validation" do
    user = create(:contractor)
    user.update_attribute(:email_address, "example@gmail.com")
    assert user.valid?

    user.update_attribute(:email_address, "example@gmail")
    refute user.valid?

    user.update_attribute(:email_address, "exampleatgmail.com")
    refute user.valid?
  end
end
