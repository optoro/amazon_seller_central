module AmazonSellerCentral
  class Page
    attr_accessor :body

    def initialize(options={})
      @page  = options.delete(:page)
      @agent = options.delete(:agent)
      @body  = @page ? @page.body : ""
    end

    def has_next?
      false
    end

    def last_page?
      !has_next?
    end

    def next_page
      raise NoNextPageAvailableError.new("Unimplemented, override Page#next_page")
    end

    class NoNextPageAvailableError < StandardError
    end

    protected
      AZN_DATE_FMT = "%m/%d/%Y"
      def parse_amazon_time(string)
        Time.strptime(string, "#{AZN_DATE_FMT} %H:%M:%S")
      end

      def parse_amazon_date(string)
        Time.strptime(string, AZN_DATE_FMT)
      end

  end
end
