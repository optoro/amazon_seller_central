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

  end
end
