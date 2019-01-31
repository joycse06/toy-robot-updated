# frozen_string_literal: true

require 'toy_robot/commands/turn_robot'

module ToyRobot
  module Commands
    describe TurnRobot do
      subject(:command) { described_class.new(robot: robot, turn_identifier: turn_identifier) }

      describe '#execute' do
        subject(:execute) { command.execute }

        let(:position) { instance_double(ValueObjects::Position, x: 2, y: 3) }
        let(:face) { Types::Directions['NORTH'] }
        let(:robot) { instance_double(Entities::Robot, position: position, face: face) }

        context 'when turn identifier is not valid' do
          let(:turn_identifier) { 'UNKNOWN' }

          it 'returns a failure' do
            expect(execute).to be_a_failure_with_value('Unknown Direction: UNKNOWN')
          end
        end

        context 'when turn_identifier is valid' do
          let(:updated_robot) { instance_double(Entities::Robot) }

          context 'when turning clockwise (RIGHT)' do
            let(:turn_identifier) { Types::TurnIdentifiers['RIGHT'] }

            before do
              expect(Entities::Robot)
                .to receive(:new)
                .with(position: position, face: new_face)
                .and_return(updated_robot)
            end

            context 'when moving forward' do
              let(:new_face) { Types::Directions['EAST'] }

              it 'returns the next direction' do
                expect(execute).to be_a_success_with_value(updated_robot)
              end
            end

            context 'when rotating back to start at the list' do
              let(:face) { Types::Directions['WEST'] }
              let(:new_face) { Types::Directions['NORTH'] }

              it 'rotates in the list and returns start direction' do
                expect(execute).to be_a_success_with_value(updated_robot)
              end
            end
          end

          context 'when turning anti-clockwise (LEFT)' do
            let(:turn_identifier) { Types::TurnIdentifiers['LEFT'] }

            before do
              expect(Entities::Robot)
                .to receive(:new)
                .with(position: position, face: new_face)
                .and_return(updated_robot)
            end

            context 'when moving backword' do
              let(:face) { Types::Directions['SOUTH'] }
              let(:new_face) { Types::Directions['EAST'] }

              it 'returns the next direction' do
                expect(execute).to be_a_success_with_value(updated_robot)
              end
            end

            context 'when rotating back to end at the list' do
              let(:face) { Types::Directions['NORTH'] }
              let(:new_face) { Types::Directions['WEST'] }

              it 'rotates in the list and returns start direction' do
                expect(execute).to be_a_success_with_value(updated_robot)
              end
            end
          end
        end
      end
    end
  end
end
