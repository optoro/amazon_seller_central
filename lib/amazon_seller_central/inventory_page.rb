module AmazonSellerCentral
  class InventoryPage < Page
    def initialize(options={})
      @page_no  = options.delete(:page_no)
      @uri_base = options.delete(:uri_base)
      super
    end

    def has_next?
      @has_next ||= @page.search(".//div[@id='nextPage']").any?
    end

    def next_page
      @next_page ||= begin
                       raise NoNextPageAvailableError unless has_next?

                       next_page = AmazonSellerCentral.mechanizer.agent.get("#{@uri_base}&searchPageOffset=#{@page_no + 1}")
                       InventoryPage.new(
                         :page => next_page,
                         :page_no => (@page_no + 1),
                         :uri_base => @uri_base
                       )
                     end
    end
  end
end
