# frozen_string_literal: true

require 'dry-struct'
require 'toy_robot/types'

module ToyRobot
  module ValueObjects
    class Table < ::Dry::Struct::Value
      attribute :length, Types::Strict::Integer.constrained(eql: Constants::TABLE_LENGTH)
      attribute :width, Types::Strict::Integer.constrained(eql: Constants::TABLE_WIDTH)

      def include_position?(x:, y:)
        x_axis_range === x && y_axis_range === y
      end

      private

      def x_axis_range
        0..(width - 1)
      end

      def y_axis_range
        0..(length - 1)
      end
    end
  end
end
