# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'simplecov'
SimpleCov.start

require 'toy_robot'
require_relative 'support/matchers/dry_rb_custom_matchers'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
