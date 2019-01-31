# frozen_string_literal: true

require 'dry/monads/result'
require 'toy_robot/types'
require 'toy_robot/entities/robot'
require 'toy_robot/commands/move_robot'
require 'toy_robot/commands/turn_robot'

module ToyRobot
  class CommandInterpreter
    extend Forwardable

    def initialize(command_descriptor:, robot:, table:)
      @command_descriptor = command_descriptor
      @robot = robot
      @table = table
    end

    def result
      return Dry::Monads::Failure('Please place the robot on the table first.') if invalid_command?

      case command_identifier
      when Types::CommandIdentifiers['PLACE']
        command_argument = command_descriptor.argument
        new_robot = Entities::Robot.new(position: command_argument.position,
                                        face: command_argument.face)
        Dry::Monads::Success(new_robot)
      when Types::CommandIdentifiers['MOVE']
        Commands::MoveRobot.new(robot: robot, table: table).execute
      when Types::CommandIdentifiers['LEFT'], Types::CommandIdentifiers['RIGHT']
        Commands::TurnRobot.new(robot: robot, turn_identifier: command_identifier).execute
      when Types::CommandIdentifiers['REPORT']
        # NO-OP, return same robot
        Dry::Monads::Success(robot)
      else
        Dry::Monads::Failure("Unknown command: #{command_identifier}")
      end
    end

    private

    attr_reader :command_descriptor, :table, :robot

    def command_identifier
      command_descriptor.identifier
    end

    def invalid_command?
      (robot.nil? &&
       command_identifier != Types::CommandIdentifiers['PLACE'])
    end
  end
end
