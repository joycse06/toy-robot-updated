# frozen_string_literal: true

require 'toy_robot/types'
require 'toy_robot/entities/robot'

module ToyRobot
  module Commands
    class TurnRobot
      def initialize(robot:, turn_identifier:)
        @robot = robot
        @turn_identifier = turn_identifier
      end

      def execute
        case turn_identifier
        when Types::TurnIdentifiers['LEFT']
          new_face = next_counter_clockwise_direction
        when Types::TurnIdentifiers['RIGHT']
          new_face = next_clockwise_direction
        else
          return Dry::Monads::Failure("Unknown Turn Command: #{turn_identifier}")
        end

        Dry::Monads::Success(updated_robot(new_face))
      end

      private

      attr_reader :turn_identifier, :robot

      def next_counter_clockwise_direction
        Types::Directions.values[(Types::Directions.values.index(robot.face) - 1) % 4]
      end

      def next_clockwise_direction
        Types::Directions.values[(Types::Directions.values.index(robot.face) + 1) % 4]
      end

      def updated_robot(new_face)
        Entities::Robot.new(position: robot.position, face: new_face)
      end
    end
  end
end
