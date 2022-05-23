IoMonitor.configure do |config|
  # Enable all available adapters for testing purposes.
  config.adapters = IoMonitor::ADAPTERS.map(&:new)
end
