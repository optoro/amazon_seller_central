require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mechanizer" do
	before :all do
		mock_seller_central_page_results!
	end

	it "retains access to the last page loaded" do
		mech = AmazonSellerCentral.mechanizer
		mech.login_to_seller_central
		mech.last_page.body.should =~ /Welcome! You are signed in as/
	end

	it "logs in and returns the home page" do
		mech = AmazonSellerCentral.mechanizer
		mech.login_to_seller_central
	end

  it "raises a LinkNotFoundError if the requested link doesn't exist" do
		mech = AmazonSellerCentral.mechanizer
		mech.login_to_seller_central
    lambda {
      mech.follow_link_with(:text => "Foo")
    }.should raise_exception(AmazonSellerCentral::Mechanizer::LinkNotFoundError)
  end

  it "resets to a nil agent" do
		mech = AmazonSellerCentral.mechanizer
		mech.login_to_seller_central
    lambda {
      mech.follow_link_with(:text => "Feedback")
    }.should_not raise_exception
    AmazonSellerCentral.mechanizer.reset!

		mech = AmazonSellerCentral.mechanizer
		mech.login_to_seller_central
    AmazonSellerCentral.mechanizer.reset!
    lambda {
      mech.follow_link_with(:text => "Feedback")
    }.should raise_exception(AmazonSellerCentral::Mechanizer::AgentResetError)
    AmazonSellerCentral.mechanizer.last_page.should be_nil
  end


end
