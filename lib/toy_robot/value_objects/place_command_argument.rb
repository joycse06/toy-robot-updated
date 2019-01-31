# frozen_string_literal: true

require 'toy_robot/types'
require 'dry-struct'
require 'toy_robot/value_objects/position'

module ToyRobot
  module ValueObjects
    class PlaceCommandArgument < ::Dry::Struct::Value
      attribute :position, ValueObjects::Position
      attribute :face, Types::Directions
    end
  end
end
