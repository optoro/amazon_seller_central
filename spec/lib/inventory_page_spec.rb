require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "InventoryPage" do
  before :all do
    @first_page  = AmazonSellerCentral::Inventory.load_first_page
    @second_page = @first_page.next_page
    @last_page   = @second_page.next_page
  end

  it "knows if there is a next page" do
    @first_page.has_next?.should be_true
    @second_page.has_next?.should be_true
    @last_page.has_next?.should be_false
  end

  it "returns the next page when there is one" do
    @first_page.next_page.body.should =~ @second_page_test_regex
  end

  it "raises an exception when asked for a next page and there is none" do
    lambda {
      @last_page.next_page
    }.should raise_exception(AmazonSellerCentral::Page::NoNextPageAvailableError)
  end

  it "knows if it is the last page" do
    @first_page.last_page?.should be_false
    @second_page.last_page?.should be_false
    @last_page.last_page?.should be_true
  end
end
