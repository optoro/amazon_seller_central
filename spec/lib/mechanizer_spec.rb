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

end
