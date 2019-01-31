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

      describe '#initialize' do
        it 'prints intro message on initialization' do
          expect { input_handler }.to output(Constants::INTRO_TEXT).to_stdout
        end
      end

      describe '#handle_input' do
        it "exits on 'quit'" do
          expect(Kernel).to receive(:exit)

          input_handler.handle_input('quit')
        end

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

          context 'when at the edge' do
            before do
              input_handler.handle_input('MOVE')
              input_handler.handle_input('MOVE')
              input_handler.handle_input('MOVE')
              input_handler.handle_input('MOVE')
            end

            it 'displays error message if asked to move further' do
              expect { input_handler.handle_input('MOVE') }
                .to output(/Moving NORTH will push robot out of table./).to_stdout
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
