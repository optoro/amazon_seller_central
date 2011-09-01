require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FeedbackPage" do
  before :all do
    #AmazonSellerCentral.mechanizer.reset!
    @first_page_test_regex  = FEEDBACK_FIRST_PAGE_TEST_REGEX
    @second_page_test_regex = FEEDBACK_SECOND_PAGE_TEST_REGEX
    @last_page_test_regex   = FEEDBACK_LAST_PAGE_TEST_REGEX

    @first_page  = AmazonSellerCentral::FeedbackPage.load_first_page
    @second_page = @first_page.next_page
    @last_page   = @second_page.next_page
  end

  it_should_behave_like "all pages"

  it "transforms itself into a collection of Feedback objects" do
    feedback = @first_page.feedbacks
    feedback.first.comments.should == "Item as described. Quick delivery."
    feedback.last.comments.should == "quick delivery.  product arrived in perfect condition.  good experience."
  end

  describe "ClassMethods" do
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
