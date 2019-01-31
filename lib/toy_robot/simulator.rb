# frozen_string_literal: true

require 'dry/matcher/result_matcher'
require 'toy_robot/types'
require 'toy_robot/value_objects/table'
require 'toy_robot/command_interpreter'

module ToyRobot
  class Simulator
    def initialize(robot:, table:)
      @robot = robot
      @table = table
    end

    def process_command(command_descriptor)
      command_result = command_execution_result(command_descriptor)

      Dry::Matcher::ResultMatcher.call(command_result) do |matcher|
        matcher.success do |robot|
          @robot = robot

          Dry::Monads::Success(build_success_message(command_descriptor))
        end

        matcher.failure do |error_message|
          Dry::Monads::Failure(error_message)
        end
      end
    end

    private

    attr_reader :robot, :table

    def build_success_message(command_descriptor)
      return robot.report if report_command?(command_descriptor)

      ''
    end

    def report_command?(command_descriptor)
      command_descriptor.identifier == Types::CommandIdentifiers['REPORT']
    end

    def command_execution_result(command_descriptor)
      CommandInterpreter.new(
        command_descriptor: command_descriptor,
        robot: robot,
        table: table
      ).result
    end
  end
end
