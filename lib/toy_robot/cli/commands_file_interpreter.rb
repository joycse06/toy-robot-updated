# frozen_string_literal: true

require 'dry/matcher/result_matcher'
require 'toy_robot/cli/constants'
require 'toy_robot/simulator'
require 'toy_robot/cli/builders/command_descriptor_from_user_input'

module ToyRobot
  module Cli
    class CommandsFileInterpreter
      def initialize(file_path, simulator)
        @file_path = file_path
        @simulator = simulator

        puts "Interpreting commands file: #{file_path} ....."
      end

      def interpret
        Kernel.exit unless file_path.file?

        IO.foreach(file_path) do |line|
          process_line(line.to_s.strip)
        end
      end

      private

      attr_reader :file_path, :simulator

      def process_line(input)
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
