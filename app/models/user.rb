class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, on: :create, presence: true, length: {minimum: 4}

  # Required for Sluggable Module
  sluggable_column :username

  # def slug_value
  #   self.username
  # end

  def generate_pin!
    self.pin = rand(10**5..(10**6-1))
    self.save
  end

  def remove_pin!
    self.pin = nil
    self.save
  end

  def phone?
    self.phone != nil
  end

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end

end