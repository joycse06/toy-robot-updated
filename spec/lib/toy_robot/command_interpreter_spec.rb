# frozen_string_literal: true

require 'toy_robot/command_interpreter'
require 'toy_robot/value_objects/place_command_argument'
require 'toy_robot/value_objects/command_descriptor'
require 'toy_robot/value_objects/table'

module ToyRobot
  describe CommandInterpreter do
    subject(:interpreter) do
      described_class.new(command_descriptor: command_descriptor, robot: robot, table: table)
    end

    let(:position) { instance_double(ValueObjects::Position, x: 2, y: 3) }
    let(:face) { Types::Directions['NORTH'] }
    let(:robot) { instance_double(Entities::Robot, position: position, face: face) }
    let(:new_robot) { instance_double(Entities::Robot) }
    let(:table) { instance_double(ValueObjects::Table) }
    let(:command_descriptor) do
      instance_double(ValueObjects::CommandDescriptor,
                      identifier: command_identifier,
                      argument: command_argument)
    end
    let(:command_argument) do
      instance_double(ValueObjects::PlaceCommandArgument, position: position, face: face)
    end

    describe '#result' do
      subject(:result) { interpreter.result }

      context 'when robot is not placed yet' do
        let(:robot) { nil }

        context 'when PLACE command sent' do
          let(:command_identifier) { Types::CommandIdentifiers['PLACE'] }

          it 'returns success with updated robot' do
            expect(Entities::Robot)
              .to receive(:new)
              .with(position: position, face: face)
              .and_return(new_robot)

            expect(result).to be_a_success_with_value(new_robot)
          end
        end

        context 'when other commands are sent' do
          let(:command_identifier) { Types::CommandIdentifiers['MOVE'] }
          let(:command_argument) { nil }

          it 'returns a failure' do
            expect(result).to be_a_failure_with_value('Please place the robot on the table first.')
          end
        end
      end

      context 'when robot is placed' do
        context 'when valid command' do
          context 'when MOVE command' do
            let(:move_command) { instance_double(Commands::MoveRobot) }
            let(:command_identifier) { Types::CommandIdentifiers['MOVE'] }

            before do
              expect(Commands::MoveRobot)
                .to receive(:new)
                .with(robot: robot, table: table)
                .and_return(move_command)
              expect(move_command).to receive(:execute).and_return(command_result)
            end

            context 'when delegated command returns failure' do
              let(:command_result) { Dry::Monads::Failure('ERROR') }

              it 'returns failure' do
                expect(result).to be_a_failure_with_value('ERROR')
              end
            end

            context 'when delegated command returns success' do
              let(:command_result) { Dry::Monads::Success(new_robot) }

              it 'returns success with updated robot' do
                expect(result).to be_a_success_with_value(new_robot)
              end
            end

          end

          context 'when PLACE command' do
            let(:command_identifier) { Types::CommandIdentifiers['PLACE'] }

            it 'returns success with updated robot' do
              expect(Entities::Robot)
                .to receive(:new)
                .with(position: position, face: face)
                .and_return(new_robot)

              expect(result).to be_a_success_with_value(new_robot)
            end
          end

          context 'when turn commands' do
            let(:turn_command) { instance_double(Commands::TurnRobot) }

            before do
              expect(Commands::TurnRobot)
                .to receive(:new)
                .with(robot: robot, turn_identifier: command_identifier)
                .and_return(turn_command)
              expect(turn_command).to receive(:execute).and_return(command_result)
            end

            context 'when delegated command returns failure' do
              let(:command_identifier) { Types::CommandIdentifiers['RIGHT'] }
              let(:command_result) { Dry::Monads::Failure('ERROR') }

              it 'returns failure' do
                expect(result).to be_a_failure_with_value('ERROR')
              end
            end

            context 'when delegated command returns success' do
              let(:command_result) { Dry::Monads::Success(new_robot) }

              context 'when RIGHT command' do
                let(:command_identifier) { Types::CommandIdentifiers['RIGHT'] }

                it 'returns success with updated robot', :aggregate_failures do
                  expect(result).to be_a_success_with_value(new_robot)
                end
              end

              context 'when LEFT command' do
                let(:command_identifier) { Types::CommandIdentifiers['LEFT'] }

                it 'returns success with updated robot' do
                  expect(result).to be_a_success_with_value(new_robot)
                end
              end
            end
          end

          context 'when REPORT command' do
            let(:command_identifier) { Types::CommandIdentifiers['REPORT'] }

            it 'returns success with same robot' do
              expect(result).to be_a_success_with_value(robot)
            end
          end
        end

        context 'when invalid command' do
          let(:command_identifier) { 'UNKNOWN' }

          it 'returns failure' do
            expect(result).to be_a_failure_with_value('Unknown command: UNKNOWN')
          end
        end
      end
    end
  end
end
