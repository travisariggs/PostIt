class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true

  def to_param
    self.slug
  end

  def generate_slug
    slug_str = self.name.gsub(' ', '-').downcase
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