module AmazonSellerCentral
  class FeedbackPage < Page
    attr_accessor :body

    def has_next?
      @has_next ||= @page.search('a').map(&:text).grep(/Next/).count > 0
    end

    def next_page
      @next_page ||= begin
                       raise NoNextPageAvailableError unless has_next?
                       page = @agent.follow_link_with(:text => 'Next')
                       FeedbackPage.new(:page => page, :agent => @agent)
                     end
    end

    def parse
      rows = @page.search('.//table[@width="100%"]').first.search('.//tr')
      rows[1..-1].map do |row|
        feedback_row_to_object(row)
      end
    end
    alias feedbacks parse

    module ClassMethods

      def load_first_page
        mech = AmazonSellerCentral.mechanizer
        mech.login_to_seller_central
        feedback_home = mech.follow_link_with(:text => "Feedback")
        feedback_page = mech.follow_link_with(:text => "View all your feedback")
        FeedbackPage.new(:page => feedback_page, :agent => mech)
      end

      def load_all_pages
        pages = [load_first_page]
        while pages.last.has_next?
          pages << pages.last.next_page
          yield pages.last if block_given?
        end
        pages
      end
      alias each_page load_all_pages

    end

    extend ClassMethods

    private
        def feedback_row_to_object(row)
          data = row.search('.//td').map(&:text)
          {
            :date              => Time.parse(data[0]),
            :rating            => data[1].to_i,
            :comments          => data[2].gsub(/\n\nRespond$/,''),
            :arrived_on_time   => yes_no_nil(data[3]),
            :item_as_described => yes_no_nil(data[4]),
            :customer_service  => yes_no_nil(data[5]),
            :order_id          => data[6],
            :rater_email       => data[7].gsub(/\s/, ''), # has a lot of \n\n\t\t crap
            :rater_role        => data[8]
          }.inject(Feedback.new){|fb, (k,v)| fb.send("#{k}=", v); fb }
        end

        def yes_no_nil(v)
          return nil if v == "-"
          v == "Yes"
        end
  end
end
