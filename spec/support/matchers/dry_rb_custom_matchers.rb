# frozen_string_literal: true

require 'dry/monads/result'

RSpec::Matchers.define :be_a_success_with_value do |expected|
  match do |actual_result|
    actual_result.instance_of?(Dry::Monads::Success) &&
      actual_result.value! == expected
  end

  failure_message do |actual_result|
    "expected that #{actual_result} would be a Success with a value of #{expected}"
  end
end

RSpec::Matchers.define :be_a_failure_with_value do |expected|
  match do |actual_result|
    actual_result.instance_of?(Dry::Monads::Failure) &&
      actual_result.failure == expected
  end

  failure_message do |actual_result|
    "expected that \"#{actual_result}\" would be a Failure with a value of #{expected}"
  end
end
