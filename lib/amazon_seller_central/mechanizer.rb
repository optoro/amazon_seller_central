require 'mechanize'
module Integrations
  module Amazon
    class Mechanizer
      MASQUERADE_AGENTS = ['Mac Safari', 'Mac FireFox', 'Linux Firefox']

      attr_reader :agent, :last_page

      def credentials
        @credentials ||= YAML.load_file(Rails.root.to_s + '/config/marketplace_credentials.yml')
      end

      def sellerId
        @sellerId ||= credentials['amazon']['blinq']['ecs']['seller_id']
      end

      def login_email
        @login_email ||= credentials['amazon']['blinq']['email']
      end

      def login_password
        @login_password ||= credentials['amazon']['blinq']['password']
      end

      def agent
        @agent ||= Mechanize.new {|ag| ag.user_agent_alias = MASQUERADE_AGENTS.rand }
      end

      def login_to_seller_central
        page = agent.get('https://sellercentral.amazon.com/')
        form = page.form_with(:name => 'signin')

        form.email = login_email
        form.password = login_password
        @last_page = form.submit
      end

      def follow_link_with(options)
        @last_page = agent.click(last_page.link_with(options))
      end
    end
  end
end
