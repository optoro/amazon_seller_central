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

    def listings(rescan=false)
      @listings = nil if rescan
      @listings ||= begin
                      set = ListingSet.new
                      @page.parser.css('table.manageTable tr').select{|r| r['id'] =~ /^sku-/ }.each do |row|
                        set << listing_row_to_object(row)
                      end
                      set
                    end
    end
    alias :parse :listings

    def apply_listings(new_listings)
      form = @page.form_with(:name => 'itemSummaryForm')
      new_listings.each do |l|
        if listings(true).find(l.sku).price.nil? && l.price != nil
          raise UnsupportedModification.new("Can't set price for #{l.asin} to $#{l.price}, the listing is not yet complete and this library doesn't yet support completing listings")
        end

        form["inv|#{l.sku}|#{l.asin}"]   = l.quantity
        form["price|#{l.sku}|#{l.asin}"] = l.price 
      end
      r = form.submit
      true
    end

    class UnsupportedModification < StandardError; end

    private

      # 0 - hidden input of sku
      # 1 - checkbox itemOffer
      # 2 - actions
      # 3 - sku
      # 4 - asin
      # 5 - product name
      # 6 - date created
      # 7 - qty
      # 8 - condition
      # 9 - your price
      # 10 - low price
      # 11 - status
      def listing_row_to_object(row)
        l = Listing.new
        row.css('td').each_with_index do |td, i|

          txt = td.text.strip # yes, slightly slower to do this here, but I type less.

          case i
          when 3
            l.sku = txt
          when 4
            l.asin = txt
          when 5
            l.product_name = txt
          when 6
            l.created_at = Time.parse(txt)
          when 7
            l.quantity = td.css('input').first['value'].to_i
          when 8
            l.condition = txt
          when 9
            l.price = get_price(td)
          when 10
            l.low_price = get_low_price(td)
          when 11
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

      def get_low_price(td)
        if td.css('a').size == 0 # no listing complete
          nil
        elsif td.css('a div').size == 1
          true
        else
          td.text.gsub(/[^\d.]/,'').to_f
        end
      end
  end
end
