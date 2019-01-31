# frozen_string_literal: true

require 'toy_robot/commands/move_robot'
require 'toy_robot/value_objects/table'

module ToyRobot
  module Commands
    describe MoveRobot do
      subject(:command) { described_class.new(robot: robot, table: table) }

      describe '#execute' do
        subject(:execute) { command.execute }

        let(:position) { instance_double(ValueObjects::Position, x: current_x, y: current_y) }
        let(:current_x) { 2 }
        let(:current_y) { 3 }
        let(:face) { Types::Directions['NORTH'] }
        let(:robot) { instance_double(Entities::Robot, position: position, face: face) }
        let(:table) { instance_double(ValueObjects::Table) }

        before do
          expect(table)
            .to receive(:include_position?)
            .with(x: new_x, y: new_y)
            .and_return(valid_move?)
        end

        context 'when facing NORTH' do
          context 'when valid move' do
            let(:updated_robot) { instance_double(Entities::Robot) }
            let(:new_x) { current_x }
            let(:new_y) { 4 }
            let(:new_position) { instance_double(ValueObjects::Position) }
            let(:valid_move?) { true }

            it 'return updated robot', :aggregate_failures do
              expect(ValueObjects::Position)
                .to receive(:new)
                .with(x: new_x, y: new_y)
                .and_return(new_position)
              expect(Entities::Robot)
                .to receive(:new)
                .with(position: new_position, face: face)
                .and_return(updated_robot)

              expect(execute).to be_a_success_with_value(updated_robot)
            end
          end

          context 'when invalid move' do
            let(:current_y) { 4 }
            let(:new_x) { current_x }
            let(:new_y) { 5 }
            let(:valid_move?) { false }

            it 'returns failure' do
              expect(execute)
                .to be_a_failure_with_value('Moving NORTH from (2,4) will push robot out of table. Ignoring.')
            end
          end
        end

        context 'when facing EAST' do
          let(:face) { Types::Directions['EAST'] }

          context 'when valid move' do
            let(:updated_robot) { instance_double(Entities::Robot) }
            let(:new_x) { 3 }
            let(:new_y) { current_y }
            let(:new_position) { instance_double(ValueObjects::Position) }
            let(:valid_move?) { true }

            it 'return updated robot' do
              expect(ValueObjects::Position)
                .to receive(:new)
                .with(x: new_x, y: new_y)
                .and_return(new_position)
              expect(Entities::Robot)
                .to receive(:new)
                .with(position: new_position, face: face)
                .and_return(updated_robot)

              expect(execute).to be_a_success_with_value(updated_robot)
            end
          end

          context 'when invalid move' do
            let(:current_x) { 4 }
            let(:new_x) { 5 }
            let(:new_y) { current_y }
            let(:valid_move?) { false }

            it 'returns failure' do
              expect(execute)
                .to be_a_failure_with_value('Moving EAST from (4,3) will push robot out of table. Ignoring.')
            end
          end
        end

        context 'when facing SOUTH' do
          let(:face) { Types::Directions['SOUTH'] }

          context 'when valid move' do
            let(:updated_robot) { instance_double(Entities::Robot) }
            let(:new_x) { current_x }
            let(:new_y) { 2 }
            let(:new_position) { instance_double(ValueObjects::Position) }
            let(:valid_move?) { true }

            it 'return updated robot' do
              expect(ValueObjects::Position)
                .to receive(:new)
                .with(x: new_x, y: new_y)
                .and_return(new_position)
              expect(Entities::Robot)
                .to receive(:new)
                .with(position: new_position, face: face)
                .and_return(updated_robot)

              expect(execute).to be_a_success_with_value(updated_robot)
            end
          end

          context 'when invalid move' do
            let(:current_y) { 0 }
            let(:new_x) { current_x }
            let(:new_y) { -1 }
            let(:valid_move?) { false }

            it 'returns failure' do
              expect(execute)
                .to be_a_failure_with_value('Moving SOUTH from (2,0) will push robot out of table. Ignoring.')
            end
          end
        end

        context 'when facing WEST' do
          let(:face) { Types::Directions['WEST'] }

          context 'when valid move' do
            let(:updated_robot) { instance_double(Entities::Robot) }
            let(:new_x) { 1 }
            let(:new_y) { current_y }
            let(:new_position) { instance_double(ValueObjects::Position) }
            let(:valid_move?) { true }

            it 'return updated robot' do
              expect(ValueObjects::Position)
                .to receive(:new)
                .with(x: new_x, y: new_y)
                .and_return(new_position)
              expect(Entities::Robot)
                .to receive(:new)
                .with(position: new_position, face: face)
                .and_return(updated_robot)

              expect(execute).to be_a_success_with_value(updated_robot)
            end
          end

          context 'when invalid move' do
            let(:current_x) { 0 }
            let(:new_x) { -1 }
            let(:new_y) { current_y }
            let(:valid_move?) { false }

            it 'returns failure' do
              expect(execute)
                .to be_a_failure_with_value('Moving WEST from (0,3) will push robot out of table. Ignoring.')
            end
          end
        end
      end
    end
  end
end
