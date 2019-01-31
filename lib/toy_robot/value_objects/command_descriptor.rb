# frozen_string_literal: true

require 'dry-struct'
require 'toy_robot/types'
require 'toy_robot/value_objects/place_command_argument'

module ToyRobot
  module ValueObjects
    class CommandDescriptor < ::Dry::Struct::Value
      attribute :identifier, Types::CommandIdentifiers
      attribute :argument, ValueObjects::PlaceCommandArgument.optional
    end
  end
end
