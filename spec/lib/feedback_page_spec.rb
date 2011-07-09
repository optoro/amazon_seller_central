require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FeedbackPage" do
  before :all do
    #AmazonSellerCentral.mechanizer.reset!
    @first_page_test_regex  = /Wow!  Amazing price, super fast shipping./
    @second_page_test_regex = /This printer was not in good shape as the seller described./
    @last_page_test_regex   = /easy to put together - ignore the first review/

    @first_page  = AmazonSellerCentral::FeedbackPage.load_first_page
    @second_page = @first_page.next_page
    @last_page   = @second_page.next_page
  end

  it "knows if there is a next page of feedback" do
    @first_page.has_next?.should be_true
    @second_page.has_next?.should be_true
    @last_page.has_next?.should be_false
  end

  it "returns the next page when there is one" do
    @first_page.next_page.body.should =~ @second_page_test_regex
  end

  it "raises an exception when asked for a next page and there is none" do
    lambda {
      @last_page.next_page
    }.should raise_exception(AmazonSellerCentral::FeedbackPage::NoNextPageAvailableError)
  end

  it "knows if it is the last page" do
    @first_page.last_page?.should be_false
    @second_page.last_page?.should be_false
    @last_page.last_page?.should be_true
  end

  it "transforms itself into a collection of Feedback objects" do
    feedback = @first_page.feedbacks
    feedback.first.comments.should == "Item as described. Quick delivery."
    feedback.last.comments.should == "quick delivery.  product arrived in perfect condition.  good experience."
  end

  describe "class methods" do
    it "loads the first page of feedback data" do
      AmazonSellerCentral.mechanizer.reset!
      page = AmazonSellerCentral::FeedbackPage.load_first_page
      page.should be_kind_of(AmazonSellerCentral::FeedbackPage)
      page.body.should =~ @first_page_test_regex
    end

    it "loads all feedback pages" do
      AmazonSellerCentral.mechanizer.reset!
      pages = AmazonSellerCentral::FeedbackPage.load_all_pages
      pages.size.should == 3
      pages.first.body.should =~ @first_page_test_regex
      pages.last.body.should =~ @last_page_test_regex
    end

    it "passes a page to a block when given" do
      last_seen = nil
      AmazonSellerCentral::FeedbackPage.each_page do |page|
        last_seen = page
      end
      last_seen.body.should =~ @last_page_test_regex
    end
  end

end
