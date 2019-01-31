# frozen_string_literal: true

require 'toy_robot/cli/commands_file_interpreter'
require 'toy_robot'

module ToyRobot
  module Cli
    describe CommandsFileInterpreter do
      subject(:commands_file_interpreter) { described_class.new(file_path, simulator) }

      let(:simulator) { Simulator.new(robot: nil, table: table)  }
      let(:table) do
        ToyRobot::ValueObjects::Table.new(length: ToyRobot::Constants::TABLE_LENGTH,
                                          width: ToyRobot::Constants::TABLE_WIDTH)
      end
      let(:file_path) { Pathname.new(ToyRobot.root).join('spec', 'fixtures', 'commands.txt') }

      describe '#initialize' do
        it 'prints intro message on initialization' do
          expect { commands_file_interpreter }
            .to output(/Interpreting commands file.*commands.txt/).to_stdout
        end
      end

      context 'when file path exists' do
        subject(:interpret) { commands_file_interpreter.interpret }

        before do
          commands_file_interpreter # to avoid intro in assertions
        end

        it 'returns the output of final report on stdout' do
          expect { interpret }
            .to output("3,3,NORTH\n").to_stdout
        end
      end
    end
  end
end
