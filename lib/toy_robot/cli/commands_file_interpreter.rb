# frozen_string_literal: true

require 'dry/matcher/result_matcher'
require 'toy_robot/cli/constants'
require 'toy_robot/cli/input_handler'
require 'toy_robot/cli/builders/command_descriptor_from_user_input'

module ToyRobot
  module Cli
    class CommandsFileInterpreter
      def initialize(file_path, input_handler)
        @file_path = file_path
        @input_handler = input_handler

        puts "Interpreting commands file: #{file_path} ....."
        puts 'Output of running commands from the file are below (everything after the seperator line).'
        puts '==========================xxxxxxxx===================='
        puts "\n"
      end

      def interpret
        Kernel.exit unless file_path.file?

        IO.foreach(file_path) do |line|
          input_handler.handle_input(line.to_s.strip)
        end
      end

      private

      attr_reader :file_path, :input_handler
    end
  end
end
