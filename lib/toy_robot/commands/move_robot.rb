# frozen_string_literal: true

require 'toy_robot/types'
require 'toy_robot/value_objects/position'
require 'toy_robot/entities/robot'

module ToyRobot
  module Commands
    class MoveRobot
      def initialize(robot:, table:)
        @robot = robot
        @table = table
      end

      def execute
        if invalid_move?
          return Dry::Monads::Failure("Moving #{robot.face} will push robot out of table. Ignoring.")
        end

        Dry::Monads::Success(updated_robot)
      end

      private

      attr_reader :robot, :table

      def updated_robot
        new_poistion = ValueObjects::Position.new(x: new_x, y: new_y)
        Entities::Robot.new(position: new_poistion, face: robot.face)
      end

      FACE_TO_MOVE_TRANSLATION_VECTOR_HASH = {
        Types::Directions['NORTH']  => [  0, +1 ],
        Types::Directions['EAST']   => [ +1,  0 ],
        Types::Directions['SOUTH']  => [  0, -1 ],
        Types::Directions['WEST']   => [ -1,  0 ]
      }.freeze

      def move_vector
        @move_vector ||=
          FACE_TO_MOVE_TRANSLATION_VECTOR_HASH[robot.face]
      end

      def invalid_move?
        !table.include_position?(x: new_x, y: new_y)
      end

      def new_x
        robot.position.x + move_vector.first
      end

      def new_y
        robot.position.y + move_vector.last
      end
    end
  end
end
