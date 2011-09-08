require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "InventoryPage" do
  before :all do
    @first_page_test_regex  = INVENTORY_FIRST_PAGE_TEST_REGEX
    @second_page_test_regex = INVENTORY_SECOND_PAGE_TEST_REGEX
    @last_page_test_regex   = INVENTORY_LAST_PAGE_TEST_REGEX
  end

  before :each do
    mock_seller_central_page_results!
    @first_page  = AmazonSellerCentral::Inventory.load_first_page
    @second_page = @first_page.next_page
    @last_page   = @second_page.next_page
  end

  it_should_behave_like "all pages"

  it "returns a ListingSet for listings" do
    listings = @first_page.listings
    listings.should be_kind_of(AmazonSellerCentral::ListingSet)
  end

  it "transforms itself into a set of Listing objects" do
    listings = @first_page.listings
    listings.size.should == 250

    listings[27].sku.should             == "PR30122-11"
    listings[27].asin.should            == "B0019MU9C2"
    listings[27].product_name.should    == "Battery Brain Platinum"
    listings[27].created_at.should      == Time.parse("2011-08-31 00:36:22")
    listings[27].quantity.should        == 0
    listings[27].condition.should       == "New"
    listings[27].price_cents.should     == nil
    listings[27].low_price.should       == nil
    listings[27].low_price_cents.should == nil
    listings[27].status.should          == "Incomplete"

    listings[1].sku.should             == "PR48458-3"
    listings[1].asin.should            == "B004O0TRDI"
    listings[1].product_name.should    == "Onkyo HT-S3400 5.1 Channel Home Theater Receiver/Speaker Package"
    listings[1].created_at.should      == Time.parse("2011-08-31 18:14:49")
    listings[1].quantity.should        == 1
    listings[1].condition.should       == "Used - Good"
    listings[1].price_cents.should     == 22559
    # listings[1].low_price.should       == true
    # listings[1].low_price_cents.should == true
    listings[1].status.should          == "Open"

    listings[10].sku.should             == "PR27880-11"
    listings[10].asin.should            == "B003962DXE"
    listings[10].product_name.should    == "Panasonic Lumix DMC-FH20K 14.1 MP Digital Camera with 8x Optical Image Stabilized Zoom and 2.7-Inch LCD (Black)"
    listings[10].created_at.should      == Time.parse("2011-08-31 10:40:13")
    listings[10].quantity.should        == 1
    listings[10].condition.should       == "New"
    listings[10].price_cents.should     == 10899
    #listings[10].low_price_cents.should == 10250
    listings[10].status.should          == "Open"
  end

  it "loads listings appropriately for another sample page" do
    # This sample page was only parsing 25 results before
    FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/ezdpc-gui/inventory-status/status.html/ref=ag_invmgr_mmap_home', :response => mock_pages[:another_listings_page])
    listings = AmazonSellerCentral::Inventory.load_first_page.listings
    listings.size.should == 250

    listings[1].sku.should             == "PR6902-2"
    listings[1].asin.should            == "B000Q82PIQ"
    listings[1].product_name.should    == "Western Digital 500 GB Caviar Blue SATA 3 Gb/s 7200 RPM 16 MB Cache Bulk/OEM Desktop Hard Drive - WD5000AAKS"
    listings[1].created_at.should      == Time.parse("2011-08-31 22:42:13")
    listings[1].quantity.should        == 1
    listings[1].condition.should       == "Used - Very Good"
    listings[1].price_cents.should     == 3819
    # listings[1].low_price.should       == true
    listings[1].status.should          == "Open"
  end

  it "accepts a set of Listing objects to apply updates to the page" do
    listings = @first_page.listings
    l = listings[0]
    # l.quantity = 0
    # l.price = 225.59
    l.quantity = 2
    l.price = 220.99

    listings = [l]

    @first_page.apply_listings(listings).should be_true

    (@first_page.instance_variable_get('@agent').last_page.parser.css('div#msg_saveSuccess')[0]['style'] !~ /display: none/).should be_true

    FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/ezdpc-gui/inventory-status/status.html/ref=ag_invmgr_mmap_home', :response => mock_pages[:update_inventory_result_from_page_1])
    listing = AmazonSellerCentral::Inventory.load_first_page.listings[0]
    listing.sku.should      == l.sku
    listing.quantity.should == l.quantity
    listing.price.should    == l.price
  end

  it "raises an unsupported modification error when trying to set the price on an incomplete listing" do
    listings = @first_page.listings
    l = listings[27]
    l.price = 24.26
    lambda {
      @first_page.apply_listings([l])
    }.should raise_exception(AmazonSellerCentral::InventoryPage::UnsupportedModification)
  end

  it "raises an unsupported modification error when trying to apply listings twice" do
    listings = @first_page.listings
    l = listings[0]
    l.price = 24.26
    @first_page.apply_listings([l])

    l.price = 26.26
    lambda {
      @first_page.apply_listings([l])
    }.should raise_exception(AmazonSellerCentral::InventoryPage::UnsupportedModification)
  end

end
