# frozen_string_literal: true

require 'dry-types'
require 'dry/monads/result'
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

    TurnIdentifiers = Types::Strict::String.enum('RIGHT', 'LEFT')

    # valid axis values values 0..TABLE_{LENGTH,WIDTH} - 1
    XAxisValue = Types::Strict::Integer
      .constrained(gteq: 0, lt: Constants::TABLE_WIDTH)
    YAxisValue = Types::Strict::Integer
      .constrained(gteq: 0, lt: Constants::TABLE_LENGTH)
  end
end
