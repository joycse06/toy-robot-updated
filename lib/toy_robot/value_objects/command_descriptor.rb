# frozen_string_literal: true

require 'dry-struct'
require 'toy_robot/types'

module ToyRobot
  module ValueObjects
    class CommandDescriptor < ::Dry::Struct::Value
      attribute :identifier, Types::CommandIdentifiers
      attribute :argument, ValueObjects::PlaceCommandArgument.optional
    end
  end
end
