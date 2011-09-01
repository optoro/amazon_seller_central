require 'fakeweb'
def mock_seller_central_page_results!
  mock_pages = {}
  Dir.glob("#{File.join(File.dirname(__FILE__), 'sample_pages')}/*.html").each do |sample_html|
    page_name = sample_html.split(/\//).last.gsub(/\.html$/,'').downcase.tr_s(' ', '_').to_sym
    mock_pages[page_name] = File.read(sample_html)
  end

  FakeWeb.allow_net_connect = false
  FakeWeb.register_uri(:any, 'https://sellercentral.amazon.com/', :response => mock_pages[:seller_central])
  FakeWeb.register_uri(:any, 'https://sellercentral.amazon.com/gp/homepage.html', :response => mock_pages[:seller_central_redirect])
  FakeWeb.register_uri(:post, 'https://sellercentral.amazon.com/gp/sign-in/sign-in.html', :response => mock_pages[:seller_central_homepage])

	# Feedback
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/home.html/ref=ag_feedback_mmap_home', :response => mock_pages[:feedback_manager])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/view-all-feedback.html?ie=UTF8&sortType=sortByDate&dateRange=&descendingOrder=1', :response => mock_pages[:feedback_page_1])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/view-all-feedback.html?ie=UTF8&sortType=sortByDate&pageSize=50&dateRange=&currentPage=2&descendingOrder=1', :response => mock_pages[:feedback_page_2])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/view-all-feedback.html?ie=UTF8&sortType=sortByDate&pageSize=50&dateRange=&currentPage=3&descendingOrder=1', :response => mock_pages[:feedback_page_last])

	# Inventory
	FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/ezdpc-gui/inventory-status/status.html/ref=ag_invmgr_mmap_home', :response => mock_pages[:listings_page_1])
	FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/ezdpc-gui/inventory-status/status.html/ref=ag_invmgr_mmap_home&searchPageOffset=2', :response => mock_pages[:listings_page_2])
	FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/ezdpc-gui/inventory-status/status.html/ref=ag_invmgr_mmap_home&searchPageOffset=3', :response => mock_pages[:listings_last_page])
end
