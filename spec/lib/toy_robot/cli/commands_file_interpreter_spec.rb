# frozen_string_literal: true

require 'toy_robot/cli/commands_file_interpreter'
require 'toy_robot'

module ToyRobot
  module Cli
    describe CommandsFileInterpreter do
      subject(:commands_file_interpreter) { described_class.new(file_path, input_handler) }

      let(:simulator) { Simulator.new(robot: nil, table: table) }
      let(:input_handler) { InputHandler.new(simulator) }
      let(:table) do
        ToyRobot::ValueObjects::Table.new(length: ToyRobot::Constants::TABLE_LENGTH,
                                          width: ToyRobot::Constants::TABLE_WIDTH)
      end
      let(:file_path) do
        Pathname
          .new(ToyRobot.root)
          .join('spec', 'fixtures', 'commands_file_with_all_valid_commands.txt')
      end

      describe '#initialize' do
        it 'prints intro message on initialization' do
          expect { commands_file_interpreter }
            .to output(/Interpreting commands file.*commands.txt.*from the file are below./m).to_stdout
        end
      end

      describe '#interpret' do
        subject(:interpret) { commands_file_interpreter.interpret }

        context 'when file path exists' do
          before do
            commands_file_interpreter # to avoid intro in assertions
          end

          context 'when all commands from the file are valid' do
            it 'returns the output of final report on stdout' do
              expect { interpret }
                .to output("3,3,NORTH\n").to_stdout
            end
          end

          context 'when a command from the file is invalid' do
            let(:file_path) do
              Pathname
                .new(ToyRobot.root)
                .join('spec', 'fixtures', 'commands_file_with_an_invalid_command.txt')
            end

            it 'displays both error and output of final report on stdout' do
              expect { interpret }
                .to output(/Please enter valid co-ordinates.*3,3,NORTH/m).to_stdout
            end
          end
        end

        context 'when file path does not exist' do
          let(:file_path) { Pathname.new('whatever') }

          it 'exits' do
            expect { interpret }.to raise_error(SystemExit)
          end
        end
      end
    end
  end
end
