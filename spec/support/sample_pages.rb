require 'fakeweb'

def mock_pages
  @mock_pages ||= begin
                    mock_pages = {}
                    Dir.glob("#{File.join(File.dirname(__FILE__), 'sample_pages')}/*.html").each do |sample_html|
                      page_name = sample_html.split(/\//).last.gsub(/\.html$/,'').downcase.tr_s(' ', '_').to_sym
                      mock_pages[page_name] = File.read(sample_html)
                    end
                    mock_pages
                  end
end

def mock_seller_central_page_results!
  FakeWeb.allow_net_connect = false
  FakeWeb.register_uri(:any, 'https://sellercentral.amazon.com/', :response => mock_pages[:seller_central])
  FakeWeb.register_uri(:any, 'https://sellercentral.amazon.com/gp/homepage.html', :response => mock_pages[:seller_central_redirect])
  FakeWeb.register_uri(:post, 'https://sellercentral.amazon.com/ap/widget', :response => mock_pages[:seller_central_homepage]) # sign in

  # Feedback
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/seller-rating/pages/feedback-manager.html/ref=ag_feedback_dnav_home_', :response => mock_pages[:feedback_manager])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/home.html/ref=ag_feedback_snav_allfeedbk', :response => mock_pages[:feedback_manager])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/view-all-feedback.html?ie=UTF8&sortType=sortByDate&dateRange=&descendingOrder=1', :response => mock_pages[:feedback_page_1])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/view-all-feedback.html?ie=UTF8&sortType=sortByDate&pageSize=50&dateRange=&currentPage=2&descendingOrder=1', :response => mock_pages[:feedback_page_2])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/gp/feedback-manager/view-all-feedback.html?ie=UTF8&sortType=sortByDate&pageSize=50&dateRange=&currentPage=3&descendingOrder=1', :response => mock_pages[:feedback_page_last])

  # Inventory
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/myi/search/DefaultView.amzn/ref=ag_invmgr_dnav_home_', :response => mock_pages[:listings_page_1])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/myi/search/DefaultView.amzn/ref=ag_invmgr_dnav_home_?searchPageOffset=2', :response => mock_pages[:listings_page_2])
  FakeWeb.register_uri(:get, 'https://sellercentral.amazon.com/myi/search/DefaultView.amzn/ref=ag_invmgr_dnav_home_?searchPageOffset=3', :response => mock_pages[:listings_last_page])
  FakeWeb.register_uri(:post, 'https://sellercentral.amazon.com/myi/search/ProductSummary', :response => mock_pages[:update_inventory_result_from_page_1])
  FakeWeb.register_uri(:post, 'https://sellercentral.amazon.com/myi/search/ProductSummary;jsessionid=10F6EC9ECBC6E9C3B45EB5DEC1B13D46', :response => mock_pages[:update_inventory_result_from_page_1])
  
  #Orders  
  FakeWeb.register_uri(:get, "https://sellercentral.amazon.com/gp/orders-v2/list/ref=ag_myo_dos4_home?"+
                                "ie=UTF8&showCancelled=0&searchType=OrderStatus&ignoreSearchType=1&statusFilter=Pending&searchFulfillers=mfn&preSelectedRange=30"+
                                "&searchDateOption=preSelected&sortBy=OrderStatusDescending&itemsPerPage=100", :response => mock_pages[:manage_orders])
  #Payments
  FakeWeb.register_uri(:get, "https://sellercentral.amazon.com/gp/payments-account/settlement-summary.html/ref=ag_payments_mmap_home", :response => mock_pages[:payments_page])  
  FakeWeb.register_uri(:get, "https://sellercentral.amazon.com/gp/payments-account/past-settlements.html/ref=ag_xx_cont_payments", :response => mock_pages[:settlement_payment_reports_1])
  FakeWeb.register_uri(:get, "https://sellercentral.amazon.com/gp/payments-account/past-settlements.html?ie=UTF8&token=njdPQHK1musSlb0KlDGD99KUYKQ%23zV7lgX5Oj0Etu_bKiIQ1nIJTcWT6_qxMQV64LHg1q9uXdxmrudQIIJAyxRmi4b-i8hLn2IWNFflMXdYTq7M8pZjxhRHSeh3KzQ8xgG_aIEPfvQe8WgLo1mCtmWWEiHY_Ya0l3gGJHMI6t3vmul2srxOxOJ5Qr78jR-rYRKqH-cdfYxrnzyXwOs9uYGVIrZk_CYB6jfQJdkrVI4SqblrlDHbXNPkNSnupUT1re4FHW-eQw4utoUrQfdWHXEzzeeNh6Tqiuv6w8A9qrNeUcSfsibK4wgQkXay4uBA6hTDOSII2iZrwvPexL3OimCWfoFkFFKP8Wipmk8rMajsPPME0ao-IbyKkDjBi0cokkTg4CxVEmOM3kT-4OI4DofYrbw1vV7wf1nL5DWZVOD4o-Y8Pmw", :response => mock_pages[:settlement_payment_reports_2])
  
end
