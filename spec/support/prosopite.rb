RSpec.configure do |config|
  config.before(:each) do
    Prosopite.scan if defined?(Prosopite)
  end

  config.after(:each) do
    Prosopite.finish if defined?(Prosopite)
  end
end
