require 'mechanize'
require 'singleton'
module AmazonSellerCentral
  class Mechanizer
    include Singleton
    MASQUERADE_AGENTS = ['Mac Safari', 'Mac FireFox', 'Linux Firefox']

    attr_reader :agent

    def login_email
      AmazonSellerCentral.configuration.login_email
    end

    def login_password
      AmazonSellerCentral.configuration.login_password
    end

    def agent
      @agent ||= Mechanize.new {|ag| ag.user_agent_alias = MASQUERADE_AGENTS[rand(MASQUERADE_AGENTS.size)] }
    end

    def last_page
      agent.current_page
    end

    def login_to_seller_central
      page = agent.get('https://sellercentral.amazon.com/')
      form = page.form_with(:name => 'signin')

      form.email    = login_email
      form.password = login_password
      form.submit
      last_page.body =~ /Welcome! You are signed in as/
    end

    def follow_link_with(options)
      raise AgentResetError unless last_page
      link = last_page.link_with(options)
      raise LinkNotFoundError unless link
      agent.click(link)
    end

    def reset!
      @agent     = nil
      #@last_page = nil
    end

    class LinkNotFoundError < StandardError; end
    class AgentResetError < StandardError; end

  end
end
