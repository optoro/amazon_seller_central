module AmazonSellerCentral
  class Listing
    attr_accessor :sku, :asin, :product_name, :created_at, :quantity, :condition, :price_cents, :low_price_cents, :status

    alias :qty :quantity
    alias :qty= :quantity=

    def price
    end
    def price=(price)
    end

    alias :your_price :price
    alias :your_price= :price=

    alias :product :product_name
    alias :product= :product_name=
  end
end
