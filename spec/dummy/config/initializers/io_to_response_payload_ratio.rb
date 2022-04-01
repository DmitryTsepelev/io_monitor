IoToResponsePayloadRatio.configure do |config|
  # Enable all available adapters for testing purposes.
  config.adapters = IoToResponsePayloadRatio::ADAPTERS.map(&:new)
end
