# frozen_string_literal: true

require 'dry-struct'
require 'toy_robot/types'

module ToyRobot
  module Entities
    class Robot < ::Dry::Struct
      attribute :position, ValueObjects::Position
      attribute :face, Types::Directions

      def report
        puts "#{position.x},#{position.y},#{face}"
      end
    end
  end
end
