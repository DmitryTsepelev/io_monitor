# frozen_string_literal: true

Rails.application.routes.draw do
  get "/fake", to: "fake#fake"
end
