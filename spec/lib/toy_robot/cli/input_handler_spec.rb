# frozen_string_literal: true

require 'toy_robot/cli/input_handler'

# treat this as integratin spec until a spec to test the console app is written

module ToyRobot
  module Cli
    describe InputHandler do
      subject(:input_handler) { described_class.new(simulator) }

      let(:simulator) { Simulator.new(robot: nil, table: table)  }
      let(:table) do
        ToyRobot::ValueObjects::Table.new(length: ToyRobot::Constants::TABLE_LENGTH,
                                          width: ToyRobot::Constants::TABLE_WIDTH)
      end

      describe '#handle_input' do
        context 'when robot is not placed yet' do
          before do
            input_handler # print output outside of assertion
          end

          context 'when place command' do
            context 'when invalid argumens' do
              context 'when x co-ordinate is invalid' do
                it 'displays error message' do
                  expect { input_handler.handle_input('PLACE x,2,WEST') }
                    .to output(/valid co-ordinates. Only integers are valid/).to_stdout
                end
              end

              context 'when y co-ordinate is invalid' do
                it 'displays error message' do
                  expect { input_handler.handle_input('PLACE 2,y,WEST') }
                    .to output(/valid co-ordinates. Only integers are valid/).to_stdout
                end
              end

              context 'when directin is invalid' do
                it 'displays error message' do
                  expect { input_handler.handle_input('PLACE 2,2,UNKNOWN') }
                    .to output(/valid direction.*UNKNOWN/).to_stdout
                end
              end
            end

            context 'when valid arguments' do
              it 'displays nothing' do
                expect { input_handler.handle_input('PLACE 2,2,NORTH') }
                  .not_to output.to_stdout
              end
            end
          end

          context 'when any other command' do
            it 'displays error message' do
              expect { input_handler.handle_input('MOVE') }
                .to output(/place the robot on the table first/).to_stdout
            end
          end
        end

        context 'when robot is placed' do
          before do
            input_handler.handle_input('PLACE 0,0,NORTH')
          end

          it 'reports correct position' do
            expect { input_handler.handle_input('REPORT') }
              .to output(/0,0,NORTH/).to_stdout
          end

          context 'when moving' do
            before do
              input_handler.handle_input('MOVE')
            end

            it 'reports correct position' do
              expect { input_handler.handle_input('REPORT') }
                .to output(/0,1,NORTH/).to_stdout
            end
          end

          context 'when empty command is entered' do
            it 'displays error message' do
              expect { input_handler.handle_input('') }
                .to output("Please enter a valid command.\n").to_stdout
            end
          end

          context 'when arguments are entered for any command other than PLACE' do
            before do
              input_handler.handle_input('PLACE 4,4,WEST')
            end

            it 'displays error message' do
              expect { input_handler.handle_input('MOVE THERE') }
                .to output("Command 'MOVE' does not take any argument(s).\n").to_stdout
            end

            context 'when error message has been displayed' do
              before do
                input_handler.handle_input('MOVE THERE')
              end

              it 'can still accept further valid arguments' do
                expect { input_handler.handle_input('MOVE'); input_handler.handle_input('REPORT') }
                  .to output(/3,4,WEST/).to_stdout
              end
            end
          end

          context 'when PLACE command is entered again' do
            context 'when place command arguments are  valid' do
              before do
                input_handler.handle_input('PLACE 4,4,WEST')
              end

              it 'reports correct position' do
                expect { input_handler.handle_input('REPORT') }
                  .to output(/4,4,WEST/).to_stdout
              end
            end

            context 'when one of place command arguments is invalid' do
              context 'when one of the co-ordinates is out of range' do
                it 'displays error' do
                  expect { input_handler.handle_input('PLACE 5,2,EAST') }
                    .to output("Please enter valid co-ordinates. Valid Range of co-ordinate values are: For X: '0-4' For Y: '0-4'\n").to_stdout
                end
              end

              context 'when one of the co-ordinates is not coercible integer' do
                it 'displays error' do
                  expect { input_handler.handle_input('PLACE X,2,EAST') }
                    .to output("Please enter valid co-ordinates. Only integers are valid.\n").to_stdout
                end
              end

              context 'when the entered direction (or face) is invalid' do
                it 'displays error' do
                  expect { input_handler.handle_input('PLACE 3,2,UNKNOWN') }
                    .to output("Please enter a valid direction. Entered: 'UNKNOWN'. Valid values are: NORTH,EAST,SOUTH,WEST\n").to_stdout
                end
              end
            end
          end

          context 'when at the edge' do
            before do
              input_handler.handle_input('MOVE')
              input_handler.handle_input('MOVE')
              input_handler.handle_input('MOVE')
              input_handler.handle_input('MOVE')
            end

            it 'displays error message if asked to move further' do
              expect { input_handler.handle_input('MOVE') }
                .to output("Moving NORTH from (0,4) will push robot out of table. Ignoring.\n").to_stdout
            end

            context 'when error messages has been displayed' do
              before do
                input_handler.handle_input('MOVE') # shows the error message
                input_handler.handle_input('RIGHT') # to ensure normal commands are still accepted
              end

              it 'reports the position correctly' do
                expect { input_handler.handle_input('REPORT') }
                  .to output(/0,4,EAST/).to_stdout
              end

              it 'can move into other directions correctly' do
                expect { input_handler.handle_input('MOVE'); input_handler.handle_input('REPORT') }
                  .to output(/1,4,EAST/).to_stdout
              end
            end
          end
        end

        context 'with examples from problem definition' do
          context 'with example a' do
            before do
              input_handler.handle_input('PLACE 0,0,NORTH')
              input_handler.handle_input('MOVE')
            end

            it 'reports correct position' do
              expect { input_handler.handle_input('REPORT') }
                .to output(/0,1,NORTH/).to_stdout
            end
          end

          context 'with example b' do
            before do
              input_handler.handle_input('PLACE 0,0,NORTH')
              input_handler.handle_input('LEFT')
            end

            it 'reports correct position' do
              expect { input_handler.handle_input('REPORT') }
                .to output(/0,0,WEST/).to_stdout
            end
          end

          context 'with example c' do
            before do
              input_handler.handle_input('PLACE 1,2,EAST')
              input_handler.handle_input('MOVE')
              input_handler.handle_input('MOVE')
              input_handler.handle_input('LEFT')
              input_handler.handle_input('MOVE')
            end

            it 'reports correct position' do
              expect { input_handler.handle_input('REPORT') }
                .to output(/3,3,NORTH/).to_stdout
            end
          end
        end
      end
    end
  end
end
