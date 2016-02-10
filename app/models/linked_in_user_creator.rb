class LinkedInUserCreator
  attr_reader :auth_hash, :user

  def initialize(user, auth_hash)
    @user = user
    @auth_hash = auth_hash
  end

  def update_user
    user.update_attributes attributes_from_linked_in
    user.errors.clear
  end

  def attributes_from_linked_in
    { first_name: first_name,
      last_name: last_name,
      bio: bio,
      city: city,
      email_address: email,
      image_path: image_url }
  end

  def provider
    auth_hash["provider"]
  end

  def uid
    auth_hash["uid"]
  end

  def first_name
    auth_hash["info"]["first_name"]
  end

  def last_name
    auth_hash["info"]["last_name"]
  end

  def email
    auth_hash["info"]["email"]
  end

  def city
    auth_hash["info"]["location"].split(",")[0]
  end

  def image_url
    auth_hash["extra"]["raw_info"]["pictureUrls"]["values"].last
  end

  def description
    auth_hash["info"]["description"]
  end

  def bio
    description
  end
end
