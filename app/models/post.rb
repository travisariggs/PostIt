class Post < ActiveRecord::Base
  # Simpler relationship declaration uses the standard naming
  #  conventions to relate things together
  #belongs_to :user
  # Could use the more explicit form for the relationship
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true

end