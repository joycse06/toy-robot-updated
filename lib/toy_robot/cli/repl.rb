# frozen_string_literal: true

require 'readline'
require 'toy_robot/cli/input_handler'

module ToyRobot
  module Cli
    class Repl
      def initialize(input_handler)
        @input_handler = input_handler

        puts Constants::INTRO_TEXT
      end

      def start
        while (line = Readline.readline('> ', true))
          input = line.strip.upcase

          Kernel.exit if input.casecmp(Constants::QUIT_COMMAND_TEXT).zero?

          input_handler.handle_input(input)
        end
      rescue Interrupt
        puts 'Ctrl-C interrupt detected. Exiting. Thanks for using Toy Robot Simulation.'
        Kernel.exit
      rescue => exception
        puts "Something went wrong. Error Message: #{exception.message}. Backtrace:"
        puts exception.backtrace
        Kernel.exit(1)
      end

      private

      attr_reader :input_handler
    end
  end
end
