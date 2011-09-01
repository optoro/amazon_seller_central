require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "InventoryPage" do
  before :all do
    @first_page_test_regex  = INVENTORY_FIRST_PAGE_TEST_REGEX
    @second_page_test_regex = INVENTORY_SECOND_PAGE_TEST_REGEX
    @last_page_test_regex   = INVENTORY_LAST_PAGE_TEST_REGEX

    @first_page  = AmazonSellerCentral::Inventory.load_first_page
    @second_page = @first_page.next_page
    @last_page   = @second_page.next_page
  end

  it_should_behave_like "all pages"

  it "transforms itself into a set of Listing objects" do
    listings = @first_page.listings
    listings.size.should == 250

    listings[0].sku.should             == "PR48698-2"
    listings[0].asin.should            == "B001AMUFMA"
    listings[0].product_name.should    == "Onkyo TX-8555 Stereo Receiver"
    listings[0].created_at.should      == Time.parse("2011-08-31 18:39:24")
    listings[0].quantity.should        == 0
    listings[0].condition.should       == "Used - Very Good"
    listings[0].price_cents.should     == nil
    listings[0].low_price.should       == nil
    listings[0].low_price_cents.should == nil
    listings[0].status.should          == "Incomplete"

    listings[1].sku.should             == "PR48458-3"
    listings[1].asin.should            == "B004O0TRDI"
    listings[1].product_name.should    == "Onkyo HT-S3400 5.1 Channel Home Theater Receiver/Speaker Package"
    listings[1].created_at.should      == Time.parse("2011-08-31 18:14:49")
    listings[1].quantity.should        == 1
    listings[1].condition.should       == "Used - Good"
    listings[1].price_cents.should     == 22559
    listings[1].low_price.should       == true
    listings[1].low_price_cents.should == true
    listings[1].status.should          == "Open"

    listings[10].sku.should             == "PR27880-11"
    listings[10].asin.should            == "B003962DXE"
    listings[10].product_name.should    == "Panasonic Lumix DMC-FH20K 14.1 MP Digital Camera with 8x Optical Image Stabilized Zoom and 2.7-Inch LCD (Black)"
    listings[10].created_at.should      == Time.parse("2011-08-31 10:40:13")
    listings[10].quantity.should        == 1
    listings[10].condition.should       == "New"
    listings[10].price_cents.should     == 10899
    listings[10].low_price_cents.should == 10250
    listings[10].status.should          == "Open"
  end

  it "accepts a set of Listing objects to apply updates to the page" do
    pending
    listings = [Listing.new, Listing.new, Listing.new]
    @page.apply_listings(listings).should be_true
    AmazonSellerCentral.mechanizer.last_page.body.should =~ /success or whatever that message is/
  end
end
