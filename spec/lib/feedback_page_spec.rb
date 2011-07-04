require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "FeedbackPage" do
  before :all do
    @first_page  = AmazonSellerCentral::FeedbackPage.new
    @second_page = AmazonSellerCentral::FeedbackPage.new
    @last_page   = AmazonSellerCentral::FeedbackPage.new
  end

  it "knows if there is a next page of feedback" do
    @first_page.has_next?.should be_true
    @second_page.has_next?.should be_true
    @last_page.has_next?.should be_false
  end

  it "knows if it is the last page" do
    @first_page.last_page?.should be_false
    @second_page.last_page?.should be_false
    @last_page.last_page?.should be_true
  end

  it "transforms itself into a collection of Feedback objects" do
    pending
    feedback = @first_page.parse
    feedback.first.comments.should =~ /whatever/
    feedback.last.comments.should =~ /whatever/
  end

  describe "class methods" do
    it "loads the first page of feedback data" do
      pending
      page = AmazonSellerCentral::FeedbackPage.load_first_page
      page.has_previous?.should be_false
    end

    it "loads all feedback pages" do
      pending
      pages = AmazonSellerCentral::FeedbackPage.load_all_pages
      pages.size.should == 3
      pages.first.body.should =~ /first page/
      pages.last.body.should =~ /last page/
    end
  end

end
