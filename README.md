# amazon_seller_central

This gem is intended to wrap Amazon's SellerCentral pages with a Ruby
API. Currently this gem supports accessing buyer feedback only.

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

## ToDo

* Access to more sections of Amazon SellerCentral.
* Rework Mechanize access to allow parallel / thread-safe usage
* **Note**: This library is likely not thread-safe. (It's untested)

## Contributing to amazon_seller_central
 
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
