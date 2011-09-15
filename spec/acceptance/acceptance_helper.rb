require 'spec_helper'

# Put your acceptance spec helpers inside spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Use culerity to test specs which require JavaScript.
require "capybara-webkit"
Capybara.javascript_driver = :webkit
