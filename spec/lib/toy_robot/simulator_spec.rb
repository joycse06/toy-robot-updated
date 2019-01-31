# frozen_string_literal: true

require 'toy_robot/simulator'
require 'toy_robot/value_objects/command_descriptor'

module ToyRobot
  describe Simulator do
    subject(:simulator) { described_class.new(robot: robot, table: table) }

    let(:position) { instance_double(ValueObjects::Position, x: 2, y: 3) }
    let(:face) { Types::Directions['NORTH'] }
    let(:robot) { instance_double(Entities::Robot, position: position, face: face) }
    let(:new_robot) { instance_double(Entities::Robot) }
    let(:table) { instance_double(ValueObjects::Table) }
    let(:command_descriptor) do
      instance_double(ValueObjects::CommandDescriptor,
                      identifier: command_identifier,
                      argument: nil )
    end
    let(:command_interpreter) { instance_double(CommandInterpreter) }

    describe '#process_command' do
      subject(:result) { simulator.process_command(command_descriptor) }

      before do
        expect(CommandInterpreter)
          .to receive(:new)
          .with(command_descriptor: command_descriptor, robot: robot, table: table)
          .and_return(command_interpreter)
        expect(command_interpreter).to receive(:result).and_return(interpreter_result)
      end

      context 'when command interpreter returns success' do
        let(:interpreter_result) { Dry::Monads::Success(new_robot) }

        context 'when REPORT command' do
          let(:command_identifier) { Types::CommandIdentifiers['REPORT'] }

          before do
            expect(new_robot).to receive(:report).and_return('2,3,NORTH')
          end

          it 'returns success', :aggregate_failures do
            expect(result).to be_a_success_with_value('2,3,NORTH')
          end

          it 'updates robot instance variable' do
            expect { result }
              .to change { simulator.send(:robot) }
              .from(robot)
              .to(new_robot)
          end
        end

        context 'when any other command' do
          let(:command_identifier) { Types::CommandIdentifiers['MOVE'] }

          it 'returns success', :aggregate_failures do
            expect(result).to be_a_success_with_value('')
          end

          it 'updates robot instance variable' do
            expect { result }
              .to change { simulator.send(:robot) }
              .from(robot)
              .to(new_robot)
          end
        end
      end

      context 'when command interpreter returns failure' do
        let(:interpreter_result) { Dry::Monads::Failure('ERROR') }
        let(:command_identifier) { Types::CommandIdentifiers['REPORT'] }

        it 'returns failure' do
          expect(result).to be_a_failure_with_value('ERROR')
        end
      end
    end
  end
end
