require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Feedback" do
  before :all do
    @feedback = AmazonSellerCentral::Feedback.new
  end
  %w{date rating comments arrived_on_time item_as_described customer_service order_id rater_email rater_role}.each do |expected_attribute|
    it "Has an attribute \"#{expected_attribute}\"" do
      @feedback.send("#{expected_attribute}=", "foo")
      @feedback.send(expected_attribute).should == "foo"
    end
  end

  it "should have a valid date format of: YYYY-mm-dd HH:MM:SS -0T00" do
    stream = File.read(File.expand_path(File.dirname(__FILE__) + '/../support/sample_pages/Feedback Page 1.html'))
    FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/feedback/', :body => stream, :content_type => 'text/html')
    agent = Mechanize.new
    page = agent.get('https://sellercentral.amazon.com/feedback/')
    fp = AmazonSellerCentral::FeedbackPage.new(:page => page, :agent => agent)
    f = fp.parse
    f.first.date.to_s.should == '2011-07-03 00:00:00 -0600'
  end
end