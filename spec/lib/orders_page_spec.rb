require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "OrdersPage" do
  describe "pending_orders" do
    it "should return an array of pending orders" do
      orders = AmazonSellerCentral::OrdersPage.pending_orders('test','test')
      orders.class.should == Array
      orders.count.should == 38
    end
  end
end
