require "capybara-webkit"
require "database_cleaner"

# Use culerity to test specs which require JavaScript.
Capybara.javascript_driver = :webkit

# Set up database cleaner to erase all tables when running
# Adapted from https://github.com/lailsonbm/contact_manager_app
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
