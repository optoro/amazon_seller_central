require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Inventory" do
  it "works like this" do
    AmazonSellerCentral::Inventory.each_page do |page|
      page.should be_kind_of(AmazonSellerCentral::InventoryPage)
    end
  end
end
