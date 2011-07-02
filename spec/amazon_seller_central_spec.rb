require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AmazonSellerCentral" do
  before :each do
    @email = Faker::Internet.email
    @password = Faker::Lorem.words
  end

  it "allows configuration" do
    AmazonSellerCentral.configure do |config|
      config.login_email @email
      config.login_password @password
    end

    AmazonSellerCentral.configuration.login_email.should == @email
    AmazonSellerCentral.configuration.login_password.should == @password
  end

  it "allows configuration in another format" do
    AmazonSellerCentral.configure do |config|
      config.login_email = @email
      config.login_password = @password
    end

    AmazonSellerCentral.configuration.login_email.should == @email
    AmazonSellerCentral.configuration.login_password.should == @password
  end
end
