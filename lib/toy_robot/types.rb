# frozen_string_literal: true

require 'dry-types'
require 'toy_robot/constants'

module ToyRobot
  module Types
    include Dry::Types.module

    Directions = Types::Strict::String.enum(
      'NORTH',
      'EAST',
      'SOUTH',
      'WEST'
    )

    CommandIdentifiers = Types::Strict::String.enum(
      'PLACE',
      'MOVE',
      'LEFT',
      'RIGHT',
      'REPORT'
    )

    # valid axis values values 0..TABLE_LENGTH{X,Y}
    XAxisValue = Types::Strict::Integer
      .constrained(gteq: 0, lteq: Constants::TABLE_LENGTH_X)
    YAxisValue = Types::Strict::Integer
      .constrained(gteq: 0, lteq: Constants::TABLE_LENGTH_Y)
  end
end
