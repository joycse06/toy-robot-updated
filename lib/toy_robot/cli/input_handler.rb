# frozen_string_literal: true

require 'dry/matcher/result_matcher'
require 'toy_robot/cli/constants'
require 'toy_robot/simulator'
require 'toy_robot/cli/builders/command_descriptor_from_user_input'

module ToyRobot
  module Cli
    class InputHandler
      def initialize(simulator)
        @simulator = simulator
      end

      def handle_input(input)
        process_input_result = process_input_result(input.upcase)

        Dry::Matcher::ResultMatcher.call(process_input_result) do |matcher|
          matcher.success do |message_to_print|
            puts message_to_print unless message_to_print.empty?
          end

          matcher.failure do |error_message|
            puts error_message
          end
        end
      end

      private

      attr_reader :simulator

      def process_input_result(input)
        build_command_descriptor(input).bind do |command_descriptor|
          simulator.process_command(command_descriptor)
        end
      end

      def build_command_descriptor(input)
        Builders::CommandDescriptorFromUserInput
          .new(input)
          .build
      end
    end
  end
end
