class Product

  attr_accessor :brand, :name, :price, :url, :asin

  def self.new_from_hash(item_hash)
      new_product = Product.new
      new_product.brand = item_hash["ItemAttributes"]["Brand"]
      new_product.name = item_hash["ItemAttributes"]["Title"]
      new_product.price = item_hash["OfferSummary"]["LowestNewPrice"]["FormattedPrice"]
      new_product.url = item_hash["DetailPageURL"]
      new_product.asin = item_hash["ASIN"]
      new_product
  end

  def display
    puts brand
    puts name
    puts price
    puts url
    puts asin
  end

end
