class Seed
  def self.start
    new.generate
  end

  def generate
    create_categories
    create_users
  end

  def create_categories
    categories = %w(Painting Digital Photography)

    categories.each do |name|
      Category.create!(name: name)
    end

    @painting = Category.find_by(name: categories[0])
    @digital = Category.find_by(name: categories[1])
    @photography = Category.find_by(name: categories[2])
  end

  def create_users
    artists = ["Brenna Martenson",
               "Taylor Moore",
               "Toni Rib"]

    artists.each do |full_name|
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
