require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Listing" do
  before :all do
    @listing = AmazonSellerCentral::Listing.new
  end
  %w{sku asin product_name created_at quantity condition price_cents low_price_cents status}.each do |expected_attribute|
    it "Has an attribute \"#{expected_attribute}\"" do
      @listing.send("#{expected_attribute}=", 31313)
      @listing.send(expected_attribute).should == 31313
    end
  end

  it "knows if a string is an asin" do
    AmazonSellerCentral::Listing.is_asin?("1234").should be_false
    AmazonSellerCentral::Listing.is_asin?("B003962DXE").should be_true
  end

  it "accepts qty as an alias for quantity" do
    @listing.quantity = 12
    @listing.qty.should == 12
    @listing.qty = 50
    @listing.quantity.should == 50
  end

  it "accepts your_price as an alias for price" do
    @listing.price = 12
    @listing.your_price.should == 12
    @listing.your_price = 50
    @listing.price.should == 50
  end

  it "accepts product as an alias for product_name" do
    @listing.product_name = 12
    @listing.product.should == 12
    @listing.product = 50
    @listing.product_name.should == 50
  end

  it "returns dollars for price" do
    @listing.price_cents = 1252
    @listing.price.should == 12.52
  end

  it "accepts dollars for price" do
    @listing.price = 52.25
    @listing.price_cents.should == 5225
  end

  it "rounds to the nearest cent when accepting dollars for price" do
    @listing.price = 52.258
    @listing.price_cents.should == 5226
    @listing.price = 52.251
    @listing.price_cents.should == 5225
  end

  it "returns dollars or true for low_price" do
    @listing.low_price_cents = 9621
    @listing.low_price.should == 96.21
    @listing.low_price_cents = true
    @listing.low_price.should == true
  end

  it "accepts nil for price" do
    @listing.price = nil
    @listing.price.should be_nil
  end

  it "accepts nil for low_price" do
    @listing.low_price = nil
    @listing.low_price.should be_nil
  end
end
