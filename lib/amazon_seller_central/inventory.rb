module AmazonSellerCentral
  class Inventory
    module ClassMethods
      def load_first_page
        mech = AmazonSellerCentral.mechanizer
        mech.login_to_seller_central
        manage_inventory = mech.follow_link_with(:text => "Manage Inventory")
        InventoryPage.new( :page => manage_inventory, :page_no => 1, :uri_base => manage_inventory.uri.to_s, :agent => mech )
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
  end
end
