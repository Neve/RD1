class AddPriceToLineItems < ActiveRecord::Migration
  def change
    #add price column
    #add_column :line_items, :price, :decimal, precision: 8, scale: 2
    LineItem.reset_column_information

    LineItem.all.each do |li|
      li.update_attribute :price, li.product.price
    end

  end
end
