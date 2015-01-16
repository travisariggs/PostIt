class Post < ActiveRecord::Base
  include Voteable

  # Simpler relationship declaration uses the standard naming
  #  conventions to relate things together
  #belongs_to :user
  # Could use the more explicit form for the relationship
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  before_save :generate_slug

  def to_param
    self.slug
  end

  def slug_value
    self.title
  end

  def generate_slug
    slug_str = self.slug_value
    # Remove leading or trailing whitespace
    slug_str = slug_str.strip
    # Make everything lower case
    slug_str = slug_str.downcase
    # Replace spaces (or groups of spaces) with '-'
    slug_str = slug_str.gsub(/\s+/, '-')
    # Get rid of weird characters (except '-')
    slug_str = slug_str.gsub(/[^\sA-Za-z0-9-]/, '')

    # Ensure that this slug is unique to our database
    self.slug = self.make_unique_slug(slug_str)
  end

  def make_unique_slug(slug_str)
    # Initialize the unique slug to the current one (it might already be unique)
    unique_slug = slug_str

    # Try to find a post with this slug
    item = self.class.find_by(slug: slug_str)

    # Loop as long as there already exists a matching slug
    #  (also ensure the matching slug isn't this item)
    counter = 2
    while item and item != self
      # The previous slug was not unique. Add a number to the end.
      unique_slug = slug_str + '-' + counter.to_s
      # Try to find the newly built slug name
      item = self.class.find_by(slug: unique_slug)
      # Prepare for the next iteration...just in case
      counter += 1
    end

    # If we've reached here, we either found the slug for this object or
    #  we got a nil from searching for a slug name (meaning that it's unique)
    return unique_slug
  end

end