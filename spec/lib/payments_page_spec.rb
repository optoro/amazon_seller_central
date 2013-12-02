require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "PaymentsPage" do
  describe "available_report_ids" do
    it "should return an array of report ids that are available for you to download from seeler central" do
      pending "Needs FakeWeb updates."
      report_ids = AmazonSellerCentral::PaymentsPage.available_report_ids
      report_ids.class.should == Array
      report_ids.count.should == 10
      report_ids[4].should == "55555555"
    end
  end
end
