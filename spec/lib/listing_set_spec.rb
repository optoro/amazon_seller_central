require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ListingSet" do
  before :all do
    @listing_set = AmazonSellerCentral::Inventory.load_first_page.listings
  end

  it "is an enumerable" do
    @listing_set.should be_kind_of(Enumerable)
  end

  it "allows find by sku" do
    listing = @listing_set.find("PR27880-11")
    listing.sku.should  == "PR27880-11"
    listing.asin.should == "B003962DXE"
  end

  it "allows find by asin" do
    listings = @listing_set.find("B0019MU9C2")
    listings.should be_kind_of(Enumerable)
    listings.first.sku.should  == "PR30122-11"
    listings.first.asin.should == "B0019MU9C2"
  end

  # it "allows where by quantity" do
  #   pending "When I need this, just thoughts for now"
  #   @listing_set.where(:quantity => 1)
  # end

  # it "allows where by price" do
  #   pending "When I need this, just thoughts for now"
  #   @listing_set.where(:price => 75.79)
  # end

  # it "allows where with gt, lt" do
  #   pending "When I need this, just thoughts for now"
  #   @listing_set.where(:price.gt => 10, :price.lt => 40)
  # end
end
