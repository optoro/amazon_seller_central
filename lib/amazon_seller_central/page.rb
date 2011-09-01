module AmazonSellerCentral
  class Page
    attr_accessor :body

    def initialize(options={})
      @page = options.delete(:page)
      @body = @page ? @page.body : ""
    end

    def has_next?
      false
    end

    def last_page?
      true
    end

    def next_page
      nil
    end

    class NoNextPageAvailableError < StandardError
    end

  end
end
