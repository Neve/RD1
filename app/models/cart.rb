class Cart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :line_items, dependent: :destroy

  # Add new product
  # increase quantity if product exists
  # or add new product item line to cart
  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
      current_item.price = current_item.product.price
    end
    current_item
  end

  # Calculates overall sum for all items in cart
  def total_price
    line_items.to_a.sum {|item| item.total_price}
  end

end
