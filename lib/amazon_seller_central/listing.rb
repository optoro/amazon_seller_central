module AmazonSellerCentral
  class Listing
    attr_accessor :sku, :asin, :product_name, :created_at, :quantity, :condition, :price_cents, :low_price_cents, :status

    alias :qty :quantity
    alias :qty= :quantity=

    alias :product :product_name
    alias :product= :product_name=

    def price
      @price_cents.kind_of?(Numeric) ? @price_cents / 100.0 : @price_cents
    end
    def price=(price)
      @price_cents = price.kind_of?(Numeric) ? (price * 100).round : price
    end

    alias :your_price :price
    alias :your_price= :price=

    def low_price
      @low_price_cents.kind_of?(Numeric) ? @low_price_cents / 100.0 : @low_price_cents
    end
    def low_price=(low_price)
      @low_price_cents = low_price.kind_of?(Numeric) ? (low_price * 100).round : low_price
    end
  end
end
