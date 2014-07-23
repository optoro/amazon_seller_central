module AmazonSellerCentral
  class OrdersPage < Page

    DATE_CELL_INDEX = 1
    ORDER_CELL_INDEX = 2
    STATUS_CELL_INDEX = 8

    attr_accessor :body

    def initialize
      @page_no = 0
    end

    def self.has_next?(page)
      has_next ||= page.search(".//div[@id='nextPage']").any?
    end

    def self.next_page(page, mech, uri_base)
      next_page ||= begin
                       raise NoNextPageAvailableError unless has_next?

                       next_page = mech.agent.get("#{uri_base}&searchPageOffset=#{@page_no + 1}")
                     end
    end

    def self.pending_orders
      uri_base = 'https://sellercentral.amazon.com/gp/orders-v2/list/ref=ag_myo_dos4_home?ie=UTF8&showCancelled=0&searchType=OrderStatus&ignoreSearchType=1&statusFilter=Pending&searchFulfillers=mfn&preSelectedRange=30&searchDateOption=preSelected&sortBy=OrderStatusDescending&itemsPerPage=100'

      mech = AmazonSellerCentral.mechanizer
      mech.login_to_seller_central
      page = mech.agent.get(uri_base)
      pending_orders = []
      begin
        (page.parser.css('tr.list-row-odd') + page.parser.css('tr.list-row-even')).each do |row|
          pending_orders << order_row_to_object(row)
        end
        if has_next?(page)
          page = next_page(page, mech, uri_base)
          had_next = true
        else
          had_next = false
        end
      end while had_next
      pending_orders
    end

    def self.order_row_to_object(row)
      o = Order.new
      row.css('td').each_with_index do |td, i|
        txt = td.text.strip
        case i
        when DATE_CELL_INDEX
          o.date = Time.parse(txt)
        when ORDER_CELL_INDEX
          o.order_id = txt.match(/^(\d{3}-\d+-\d+)\s/)[1]
        when STATUS_CELL_INDEX
          o.status = txt
        end
      end
      o
    end
  end
end
