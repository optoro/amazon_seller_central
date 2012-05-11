module AmazonSellerCentral
  class PaymentsPage < Page
    attr_accessor :body
    
    def has_next?
      @has_next ||= @page.search('a').map(&:text).grep(/Next/).any?
    end

    def next_page
      @next_page ||= begin
                       raise NoNextPageAvailableError unless has_next?
                       page = @agent.follow_link_with(:text => 'Next')
                       PaymentsPage.new(:page => page, :agent => @agent)
                     end
    end

    def get_all_availble_report_ids
      id_array = []
      mech = AmazonSellerCentral.mechanizer
      mech.login_to_seller_central
      mech.follow_link_with(:text => "Payments")
      current_settlements_page = mech.follow_link_with(:text => "Past Settlements")
      current_page = PaymentsPage.new(:page => current_settlements_page, :agent => mech)     
      id_array << current_page.page.links_with(:text => "Download Flat File").map{|link| link.href.match(/_GET_FLAT_FILE_PAYMENT_SETTLEMENT_DATA__(\d+)\.txt/)[1]}
      while(current_page.has_next?)
        current_page = current_page.next_page
        id_array << current_page.page.links_with(:text => "Download Flat File").map{|link| link.href.match(/_GET_FLAT_FILE_PAYMENT_SETTLEMENT_DATA__(\d+)\.txt/)[1]}
      end    
    end
  end
end
