# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# standard: disable Bundler/DuplicatedGem
if (rails_version = ENV["RAILS_VERSION"])
  case rails_version
  when "HEAD"
    git "https://github.com/rails/rails.git" do
      gem "rails"
    end
  else
    rails_version = "~> #{rails_version}.0" if rails_version.match?(/^\d+\.\d+$/) # "7.0" => "~> 7.0.0"
    gem "rails", rails_version
  end
end
# standard: enable Bundler/DuplicatedGem

gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
gem "rspec-rails", "~> 5.0"
gem "with_model", "~> 2.0"
gem "database_cleaner-active_record", "~> 2.0"
gem "standard", "~> 1.3"
gem "simplecov", "~> 0.21.0"
gem "pry"
gem "webmock", "~> 3.14"

# Dummy app dependencies
gem "sqlite3", "~> 1.4"
