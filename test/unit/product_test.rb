require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  # test "the truth" do
  #   assert true
  # end

def new_test_product(image_url = "image.jpg" )
  product = Product.new(
    title: "My book title",
    description: "Test description for unit tests",
    price: 1,
    image_url: image_url
  )
   return product
  end


  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = new_test_product
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01" ||
      "Price must be less than or equal to 100500.01",
      product.errors[:price].join('; ')

    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    product.price = 1
    assert product.valid?

  end

  test "image url test" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.PNG http;//ex.com/fred.jpg}
    bad = %w{fred.doc fred.gif/mode fred.gif.more}

    ok.each do |item|
      assert new_test_product(item).valid? "#{item} should be valid"
    end

    bad.each do |item|
      assert new_test_product(item).invalid? "#{item} should be invalid"
    end

  end

  test "product is not valid without unique title" do
    product = Product.new(
      title: products(:ruby).title,
      description: "Test description for unit tests",
      image_url: "image.jpg"
    )
    assert !product.save
    #"has already been taken",
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
      product.errors[:title].join('; ')

  end

end
