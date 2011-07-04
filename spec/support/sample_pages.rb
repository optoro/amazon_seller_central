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

end
