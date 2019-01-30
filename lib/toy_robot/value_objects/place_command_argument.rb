# frozen_string_literal: true

require 'dry-types'
require 'toy_robot/types'

module ToyRobot
  module ValueObjects
    class PlaceCommandArgument < ::Dry::Struct::Value
      attribute :position, ValueObjects::Position
      attribute :face, Types::Directions
    end
  end
end
