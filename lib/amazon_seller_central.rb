require 'amazon_seller_central/configuration'
#require 'amazon_seller_central/mechanizer'
#require 'amazon_seller_central/feedback'

module AmazonSellerCentral
  def self.configuration
    @configuration ||= AmazonSellerCentral::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
