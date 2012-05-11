module AmazonSellerCentral
  class InventoryPage < Page
    def initialize(options={})
      @listings_applied = false
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

                       next_page = @agent.agent.get("#{@uri_base}&searchPageOffset=#{@page_no + 1}")
                       InventoryPage.new(
                         :page => next_page,
                         :page_no => (@page_no + 1),
                         :uri_base => @uri_base,
                         :agent => @agent
                       )
                     end
    end

    def listings(rescan=false)
      @listings = nil if rescan
      @listings ||= begin
                      set = ListingSet.new
                      # being more specific here breaks on some pages
                      @page.parser.css('tr').select{|r| r['id'] =~ /^sku-/ && r.css('td').size == 13 }.each do |row|
                        set << listing_row_to_object(row)
                      end
                      set
                    end
    end
    alias :parse :listings

    def apply_listings(new_listings)
      if @listings_applied
        raise UnsupportedModification.new("Can't apply listing data twice from the same page object. Refetch this page before attempting to update listings")
      end

      form = @page.form_with(:name => 'itemSummaryForm')
      new_listings.each do |l|
        if listings(true).find(l.sku).price.nil? && l.price != nil
          raise UnsupportedModification.new("Can't set price for #{l.asin} to $#{l.price}, the listing is not yet complete and this library doesn't yet support completing listings")
        end

        form["inv|#{l.sku}|#{l.asin}"]   = l.quantity
        form["price|#{l.sku}|#{l.asin}"] = l.price 
      end
      form['formOperation'] = 'saveChanges'
      r = form.submit
      @listings_applied = true
      true
    end

    class UnsupportedModification < StandardError; end

    private

      # 0 - hidden input of sku
      # 1 - checkbox itemOffer
      # 2 - actions
      # 3 - status
      # 4 - sku
      # 5 - asin
      # 6 - product name
      # 7 - date created
      # 8 - qty
      # 9 - condition
      # 10 - your price
      # 11 - low price
      def listing_row_to_object(row)
        l = Listing.new
        row.css('td').each_with_index do |td, i|

          txt = td.text.strip # yes, slightly slower to do this here, but I type less.

          case i
          when 4
            l.sku = txt
          when 5
            l.asin = txt
          when 6
            l.product_name = txt
          when 7
            l.created_at = parse_amazon_time(txt)
          when 8
            l.quantity = (inputs = td.css('input')).any? ? inputs.first['value'].to_i : txt.to_i
          when 9
            l.condition = txt
          when 10
            l.price = get_price(td)
          when 11
            l.low_price = get_low_price(td)
          when 3
            l.status = txt
          end
        end
        l
      end

      def get_price(td)
        if td.css('input').size == 0 # incomplete listing
          nil
        else
          td.css('input').first['value'].to_f
        end
      end

      # Turns out you can't get this without a subrequest
      def get_low_price(td)
        nil
        # if td.css('a').size == 0 # no listing complete
        #   nil
        # elsif td.css('a div').size == 1
        #   true
        # else
        #   td.text.gsub(/[^\d.]/,'').to_f
        # end
      end
  end
end
