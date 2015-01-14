class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, on: :create, presence: true, length: {minimum: 4}

  before_save :generate_slug

  def to_param
    self.slug
  end

  def generate_slug
    slug_str = self.username.gsub(' ', '-').downcase
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

end