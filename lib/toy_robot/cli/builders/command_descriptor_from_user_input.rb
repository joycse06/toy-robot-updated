# frozen_string_literal: true

require 'toy_robot/types'
require 'toy_robot/cli/builders/place_command_argument_from_user_input'
require 'toy_robot/value_objects/command_descriptor'

module ToyRobot
  module Cli
    module Builders
      class CommandDescriptorFromUserInput
        def initialize(user_input)
          @user_input = user_input
        end

        def build
          return Dry::Monads::Failure('Please enter a valid command.') if user_input.empty?

          build_command_identifier.bind do |command_identifier|
            @command_identifier = command_identifier
            build_command_argument(command_identifier)
          end.bind do |argument|
            command_descriptor =
              ValueObjects::CommandDescriptor.new(identifier: @command_identifier, argument: argument)
            Dry::Monads::Success(command_descriptor)
          end
        end

        private

        attr_reader :user_input

        def build_command_identifier
          Dry::Monads::Success(Types::CommandIdentifiers[raw_command_identifier])
        rescue Dry::Types::ConstraintError => _exception
          Dry::Monads::Failure("Unknown command: '#{user_input}'. Please enter a valid command.")
        end

        def build_command_argument(command_identifier)
          case command_identifier
          when Types::CommandIdentifiers['PLACE']
            build_place_argument
          else
            return Dry::Monads::Failure("Command: '#{command_identifier}' does not take argument(s).") if command_with_argument?
            Dry::Monads::Success(nil)
          end
        end

        def build_place_argument
          PlaceCommandArgumentFromUserInput.new(raw_command_arguments.to_s).build
        end

        def command_with_argument?
          user_input.split(' ').size > 1
        end

        def raw_command_identifier
          user_input.split(' ')[0].strip
        end

        def raw_command_arguments
          user_input.split(' ')[1]
        end
      end
    end
  end
end
