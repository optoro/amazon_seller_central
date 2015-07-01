require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Inventory" do
  it "loads the first page of inventory data" do
    AmazonSellerCentral.mechanizer.reset!
    page = AmazonSellerCentral::Inventory.load_first_page
    page.should be_kind_of(AmazonSellerCentral::InventoryPage)
    page.body.should =~ INVENTORY_FIRST_PAGE_TEST_REGEX
  end

  it "loads all inventory pages" do
    AmazonSellerCentral.mechanizer.reset!
    pages = AmazonSellerCentral::Inventory.load_all_pages
    pages.size.should == 3
    pages.first.body.should =~ INVENTORY_FIRST_PAGE_TEST_REGEX
    pages.last.body.should =~ INVENTORY_LAST_PAGE_TEST_REGEX
  end

  it "passes a page to a block when given" do
    pending
    last_seen = nil
    AmazonSellerCentral::Inventory.each_page do |page|
      last_seen = page
    end
    last_seen.body.should =~ INVENTORY_LAST_PAGE_TEST_REGEX
  end
end
