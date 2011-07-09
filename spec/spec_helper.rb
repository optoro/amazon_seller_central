$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'faker'
require 'amazon_seller_central'
require 'ruby-debug'

if Debugger.respond_to?(:settings)
  Debugger.settings[:autoeval] = true
  Debugger.settings[:autolist] = 1
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end
