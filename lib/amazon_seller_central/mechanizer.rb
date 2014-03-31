require 'mechanize'
module AmazonSellerCentral
  class Mechanizer
    MASQUERADE_AGENTS = ['Mac Safari', 'Mac FireFox', 'Linux Firefox', 'Windows IE 9']

    # constants for the verification page if logged in from a new device
    VERIF_PAGE_PATTERN      = /What is the ZIP Code/
    VERIF_PAGE_FORM_NAME    = 'ap_dcq_form'
    VERIF_PAGE_FIELD_NAME   = 'dcq_question_subjective_1'
    VERIF_PAGE_ZIP_CODE     = '20706'

    attr_reader :agent

    def initialize
      @logged_in = false
    end

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
      return true if @logged_in
      tries = 3
      begin
        tries -= 1
        page = agent.get('https://sellercentral.amazon.com/gp/homepage.html')
        form = page.form_with(:name => 'signinWidget')

        begin
          form['username']    = login_email
          form['password']    = login_password
          p = form.submit

          if p =~ /better protect/ # capcha!
            raise CapchaPresentError.new("Holy CAPCHA Batman!")
          end
          @logged_in = !!( p.body =~ /Logout/ && p.body =~ /Manage Inventory/ )

        rescue StandardError => e
          File.open("/tmp/seller_central_#{Time.now.to_i}.html","wb") do |f|
            f.write page.body
          end
          raise e
        end

        # New device verification
        if p.body =~ VERIF_PAGE_PATTERN
          form = p.form_with(:name => VERIF_PAGE_FORM_NAME)
          form[VERIF_PAGE_FIELD_NAME] = VERIF_PAGE_ZIP_CODE
          p = form.submit # This raises a response code error, :-(
        end

      rescue Mechanize::ResponseCodeError
        retry if tries > 0
        raise
      end

    end

    def follow_link_with(options)
      raise AgentResetError unless last_page
      link = last_page.link_with(options)
      raise LinkNotFoundError unless link
      agent.click(link)
    end

    def reset!
      @agent     = nil
      @logged_in = false
      #@last_page = nil
    end

    class LinkNotFoundError < StandardError; end
    class AgentResetError < StandardError; end
    class CapchaPresentError < StandardError; end

  end
end
