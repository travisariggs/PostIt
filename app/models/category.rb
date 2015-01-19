class Category < ActiveRecord::Base
  include Sluggable

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true

  # Required for Sluggable Module
  sluggable_column :name

  # def slug_value
  #   self.name
  # end

end