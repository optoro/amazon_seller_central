require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ListingSet" do
  before :all do
    @listing_set = AmazonSellerCentral::Inventory.load_first_page.listings
  end

  it "is an enumerable" do
    @listing_set.should be_kind_of(Enumerable)
  end

  it "allows find by sku" do
    listing = @listing_set.find("PR51341-2")
    listing.sku.should  == "PR51341-2"
    listing.asin.should == "B003NE5JJW"
  end

  it "allows find by asin" do
    listings = @listing_set.find("B0045JLPMY")
    listings.should be_kind_of(Enumerable)
    listings.first.sku.should  == "PR52729-3"
    listings.first.asin.should == "B0045JLPMY"
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
