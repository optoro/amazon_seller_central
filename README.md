[No longer supported.  Deprecated.]

# amazon\_seller\_central

This gem wraps Amazon's SellerCentral pages with a Ruby API.
Currently this gem supports accessing buyer feedback, accessing
current inventory listings, and simple updates to those listings.

## Setup

You need to require the gem and then provide the email address and
password you use to login to Amazon SellerCentral via the
`AmazonSellerCentral.configure` method:

    require 'amazon_seller_central'

    AmazonSellerCentral.configure do |config|
      config.login_email    "seller@mydomain.com"
      config.login_password "secret"
    end

## Feedback Access

After configuration, the easiest way to access your feedback is using
the block form:

    AmazonSellerCentral::FeedbackPage.each_page do |page|
      feedbacks = page.feedbacks
      feedback = feedbacks.first

      feedback.arrived_on_time   # true, false, or nil
      feedback.comments          # The feedback left ("Excellent transaction!")
      feedback.customer_service  # true, false, or nil
      feedback.date              # A Time object
      feedback.item_as_described # true, false, or nil
      feedback.order_id          # An Amazon Order ID, like 123-1234567-1234567
      feedback.rater_email       # something_scrambled@marketplace.amazon.com
      feedback.rater_role        # typically "Buyer"
      feedback.rating            # an integer, 1 - 5
    end

## Inventory Access

You can access current inventory in much the same way as feedback:

    AmazonSellerCentral::Inventory.each_page do |page|
      listings = page.listings
      listing = listings.first

      listing.sku          # <Your sku for this listing>
      listing.asin         # An ASIN, e.g. B003962DXE
      listing.product_name # The name of the product
      listing.created_at   # a Time object representing when you created this listing
      listing.quantity     # an integer
      listing.condition    # "New" or "Used - Very Good" or whichever
      listing.price_cents  # an integer of cents. listing.price is also available to get dollars
      listing.status       # "Open", "Closed (Out of Stock)", or "Incomplete"
    end

## Updating Inventory

Currently this gem supports updating a listing you've already created
via the web interface or some other API. Future versions may include
creating listing entries from scratch.

To update a listing, you use `ListingPage#apply_listings`, like so:

    # alternately get a page inside the 'each_page' method above
    page = AmazonSellerCentral::Inventory.load_first_page
    # Updating a listing for my sku, "PR6902-2":
    listing = page.listings.find("PR6902-2")
    listing.quantity = 10
    listing.price_cents = 1599
    # Note the array syntax here allows you to update multiple listings
    # on this page at the same time.
    page.apply_listings([listing])

## TODO

* Access to more sections of Amazon SellerCentral.
* Rework Mechanize access to allow parallel / thread-safe usage
* **Note**: This library is likely not thread-safe. (It's untested)

## Contributing to amazon\_seller\_central

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Optoro, Inc. See LICENSE.txt for
further details.
