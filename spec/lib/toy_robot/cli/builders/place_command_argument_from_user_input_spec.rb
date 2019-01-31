# frozen_string_literal: true

require 'toy_robot/cli/builders/place_command_argument_from_user_input'

module ToyRobot
  module Cli
    module Builders
      describe PlaceCommandArgumentFromUserInput do
        subject(:builder) { described_class.new(raw_arguments) }

        describe '#build' do
          subject(:build) { builder.build }

          context 'when argument does not have 3 parts' do
            let(:raw_arguments) { '3' }

            it 'returns a failure' do
              expect(build.failure)
                .to match(/Wrong number of arguments.*Input Args: '3'/)
            end
          end

          context 'when argument has 3 parts' do
            context 'when all arguments are correct' do
              let(:raw_arguments) { '2,3,WEST' }
              let(:place_command_argument) { instance_double(ValueObjects::PlaceCommandArgument) }
              let(:position) { instance_double(ValueObjects::Position) }

              before do
                expect(ValueObjects::Position)
                  .to receive(:new)
                  .with(x: 2, y: 3)
                  .and_return(position)
                expect(ValueObjects::PlaceCommandArgument)
                  .to receive(:new)
                  .with(position: position, face: 'WEST')
                  .and_return(place_command_argument)
              end

              it 'return the built value object' do
                expect(build).to be_a_success_with_value(place_command_argument)
              end

              context 'when arguments has extra spaces' do
                let(:raw_arguments) { '2, 3, WEST   ' }

                it 'return the built value object' do
                  expect(build).to be_a_success_with_value(place_command_argument)
                end
              end
            end

            context 'when called with invalid arguments' do
              context 'when x co-ordinate is not a coercible integer' do
                let(:raw_arguments) { 'X,2,WEST' }

                it 'returns a failure' do
                  expect(build.failure).to match(/Please enter valid.*Only integers are valid/)
                end
              end

              context 'when x co-ordinate is not within range' do
                let(:raw_arguments) { '8,2,WEST' }

                it 'returns a failure' do
                  expect(build.failure)
                    .to match(/Please enter valid.*For X: '0-4'.*For Y: '0-4'/)
                end
              end

              context 'when y co-ordinate is not a coercible integer' do
                let(:raw_arguments) { '2,Y,WEST' }

                it 'returns a failure' do
                  expect(build.failure).to match(/Please enter valid.*Only integers are valid/)
                end
              end

              context 'when y co-ordinate is not within range' do
                let(:raw_arguments) { '2,8,WEST' }

                it 'returns a failure' do
                  expect(build.failure)
                    .to match(/Please enter valid.*For X: '0-4'.*For Y: '0-4'/)
                end
              end

              context 'when direction is not valid' do
                let(:raw_arguments) { '2,2,INVALID' }
                let(:position) { instance_double(ValueObjects::Position) }

                it 'returns a failure', :aggregate_failures do
                  expect(ValueObjects::Position)
                    .to receive(:new)
                    .with(x: 2, y: 2)
                    .and_return(position)
                  expect(build.failure)
                    .to match(/enter a valid direction. Entered: 'INVALID'. Valid values are: NORTH,EAST,SOUTH,WEST/)
                end
              end
            end
          end
        end
      end
    end
  end
end
