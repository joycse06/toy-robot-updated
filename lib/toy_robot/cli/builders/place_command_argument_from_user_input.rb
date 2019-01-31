# frozen_string_literal: true

require 'toy_robot/types'
require 'toy_robot/value_objects/place_command_argument'
require 'toy_robot/value_objects/position'

module ToyRobot
  module Cli
    module Builders
      class PlaceCommandArgumentFromUserInput
        def initialize(raw_args)
          @raw_args = raw_args.strip
        end

        def build
          if num_of_arguments != 3
            return Dry::Monads::Failure("Wrong number of arguments passed to PLACE command. Input Args: '#{raw_args}'. Please enter exactly 3 arguments like X,Y,DIRECTION")
          end

          build_position.bind do |position|
            @position = position
            build_face
          end.bind do |face|
            place_command_argument =
              ValueObjects::PlaceCommandArgument.new(position: @position, face: face)
            Dry::Monads::Success(place_command_argument)
          end
        end

        private

        attr_reader :raw_args

        def build_position
          Dry::Monads::Success(ValueObjects::Position.new(x: x_axis_value, y: y_axis_value))
        rescue Dry::Struct::Error => _exception
          invalid_range_error_message = 'Please enter valid co-ordinates. ' \
            "Valid Range of co-ordinate values are: For X: '0-#{Constants::TABLE_WIDTH-1}' " \
            "For Y: '0-#{Constants::TABLE_LENGTH - 1}'"
          Dry::Monads::Failure(invalid_range_error_message)
        rescue ArgumentError
          Dry::Monads::Failure('Please enter valid co-ordinates. Only integers are valid.')
        end

        def build_face
          raw_face = argument_parts[2]
          Dry::Monads::Success(Types::Directions[raw_face])
        rescue Dry::Types::ConstraintError => _exception
          Dry::Monads::Failure("Please enter a valid direction. Entered: '#{raw_face}'. Valid values are: #{Types::Directions.values.join(',')}")
        end

        def x_axis_value
          Integer(argument_parts[0])
        end

        def y_axis_value
          Integer(argument_parts[1])
        end

        def num_of_arguments
          argument_parts.size
        end

        def argument_parts
          @argument_parts ||= raw_args.split(',').map(&:strip)
        end
      end
    end
  end
end
