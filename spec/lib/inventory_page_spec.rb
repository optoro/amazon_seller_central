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
    pending('test html files are out of date, tds now 14')
    listings = @first_page.listings
    listings.size.should == 250

    listings[3].sku.should             == "PR131121-11"
    listings[3].asin.should            == "B0015AB7U6"
    listings[3].product_name.should    == "Pinnacle Speakers PS Sub 225 12-Inch 225 Watt Front Firing Powered Subwoofer (Black)"
    listings[3].created_at.should      == Time.parse("2013-12-02 10:52:21")
    listings[3].quantity.should        == 0
    listings[3].condition.should       == "New"
    listings[3].price_cents.should     == 19069
    listings[3].low_price.should       == nil
    listings[3].low_price_cents.should == nil
    listings[3].status.should          == "Inactive (Out of Stock)"

    listings[0].sku.should             == "PR111001-1"
    listings[0].asin.should            == "B00C81G378"
    listings[0].product_name.should    == 'Ematic 7" Pro Google Android 4.0 Capacitive Multi-Touch Tablet 4GB w/WiFi Black'
    listings[0].created_at.should      == Time.parse("2013-12-02 11:03:04")
    listings[0].quantity.should        == 0
    listings[0].condition.should       == "Used - Like New"
    listings[0].price_cents.should     == 4899
    listings[0].status.should          == "Inactive (Out of Stock)"
  end

  # it "loads listings appropriately for another sample page" do
  #   # This sample page was only parsing 25 results before
  #   FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/ezdpc-gui/inventory-status/status.html/ref=ag_invmgr_mmap_home', :response => mock_pages[:another_listings_page])
  #   listings = AmazonSellerCentral::Inventory.load_first_page.listings
  #   listings.size.should == 250

  #   listings[1].sku.should             == "PR6902-2"
  #   listings[1].asin.should            == "B000Q82PIQ"
  #   listings[1].product_name.should    == "Western Digital 500 GB Caviar Blue SATA 3 Gb/s 7200 RPM 16 MB Cache Bulk/OEM Desktop Hard Drive - WD5000AAKS"
  #   listings[1].created_at.should      == Time.parse("2011-08-31 22:42:13")
  #   listings[1].quantity.should        == 1
  #   listings[1].condition.should       == "Used - Very Good"
  #   listings[1].price_cents.should     == 3819
  #   # listings[1].low_price.should       == true
  #   listings[1].status.should          == "Active"
  # end

  it "accepts a set of Listing objects to apply updates to the page" do
    pending "Needs FakeWeb updates."
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
    pending "Needs FakeWeb updates."
    listings = @first_page.listings
    l = listings[2]
    l.price = 24.26
    lambda {
      @first_page.apply_listings([l])
    }.should raise_exception(AmazonSellerCentral::InventoryPage::UnsupportedModification)
  end

  it "raises an unsupported modification error when trying to apply listings twice" do
    pending('Test html pages are out of date.')
    listings = @first_page.listings
    l = listings[6]
    l.price = 24.26
    @first_page.apply_listings([l])

    l.price = 26.26
    lambda {
      @first_page.apply_listings([l])
    }.should raise_exception(AmazonSellerCentral::InventoryPage::UnsupportedModification)
  end

end
