require 'amazon_seller_central/configuration'
require 'amazon_seller_central/mechanizer'
require 'amazon_seller_central/listing_set'
require 'amazon_seller_central/page'
require 'amazon_seller_central/feedback'
require 'amazon_seller_central/feedback_page'
require 'amazon_seller_central/listing'
require 'amazon_seller_central/inventory'
require 'amazon_seller_central/inventory_page'
require 'amazon_seller_central/order'
require 'amazon_seller_central/orders_page'

module AmazonSellerCentral
  def self.configuration
    @configuration ||= AmazonSellerCentral::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.mechanizer
    AmazonSellerCentral::Mechanizer.new
  end
end
