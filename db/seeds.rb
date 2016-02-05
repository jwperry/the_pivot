class Seed
  def self.start
    new.generate
  end

  def generate
    create_categories
    create_users
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

  def create_users
    users = ["Joseph Perry",
             "Dan Winter",
             "Toni Rib",
             "Josh Mejia"]

    users.each do |full_name|
      first_name = full_name.split.first
      last_name = full_name.split.last

      User.create!(first_name: first_name,
                   last_name: last_name,
                   username: "#{first_name.downcase}_user",
                   password: "password",
                   role: 0,
                   email_address: "#{first_name.downcase}@turing.io",
                   street_address: Faker::Address.street_address,
                   city: Faker::Address.city,
                   state: Faker::Address.state,
                   zipcode: Faker::Address.zip,
                   bio: Faker::Lorem.sentence(3))
    puts "Created user: #{full_name}"
    end

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
        bio: Faker::Lorem.sentence(3)
      )

      puts "Created user: #{first_name} #{last_name}"
    end
  end
end

Seed.start
