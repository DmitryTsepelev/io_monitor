# frozen_string_literal: true

class FakeController < ApplicationController
  include IoMonitor::Controller

  def fake
    raise ActionController::RoutingError.new("Fake")
  end
end
