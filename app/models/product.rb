class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title

  validates :title, :description, :image_url,
    presence: true

  validates :price,
    numericality: {greater_than_or_equal_to: 0.01}

  validates :title,
    uniqueness: true,
    length: {
      minimum: 10,
      message: ' length is incorrect, should be > 10'
    }


  validates :image_url,
    allow_blank: true,
    format: {
      with: %r{\.(gif|jpg|png)$}i,
      message: ' should end with (gif|jpg|png) '
    }

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'exists in one of the carts')
      return false
    end
  end

end