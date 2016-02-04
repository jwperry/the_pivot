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

    categories.each { |name| Category.create!(name: name) }
  end

  def create_users
    users = ["Joseph Perry",
             "Dan Winter",
             "Toni Rib"]

    users.each do |full_name|
      first_name = full_name.split.first
      last_name = full_name.split.last

      User.create!(first_name: first_name,
                   last_name: last_name,
                   username: "#{first_name.downcase}_user",
                   password: "password",
                   role: 0,
                   email_address: "#{first_name.downcase}_user@gmail.com",
                   street_address: "123 Maple Drive",
                   city: "Denver",
                   state: "CO",
                   zipcode: 80231)
    end
  end
end

Seed.start
