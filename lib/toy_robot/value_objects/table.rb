# frozen_string_literal: true

require 'dry-struct'
require 'toy_robot/types'

module ToyRobot
  module ValueObjects
    class Table < ::Dry::Struct::Value
      attribute :length, Types::Strict::Integer.constrained(eql: Constants::TABLE_LENGTH_X)
      attribute :width, Types::Strict::Integer.constrained(eql: Constants::TABLE_LENGTH_Y)
    end
  end
end
