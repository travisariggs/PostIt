class Post < ActiveRecord::Base
  # Simpler relationship declaration uses the standard naming
  #  conventions to relate things together
  #belongs_to :user
  # Could use the more explicit form for the relationship
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  after_validation :generate_slug

  def to_param
    self.slug
  end

  def generate_slug
    slug_str = self.title.gsub(' ', '-').downcase
    self.slug = self.clean_string(slug_str)
  end

  def clean_string(s)
    bad = ['!','@','#','$','%','^','&','*','(',')','+','=',
           '[',']','{','}','|','/','<','>','?',',','.','~',
           '`']
    bad.each do |b|
      s.tr!(b,'')
    end

    return s
  end

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

end