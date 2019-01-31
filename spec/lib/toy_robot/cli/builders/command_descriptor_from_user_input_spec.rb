# frozen_string_literal: true

require 'toy_robot/cli/builders/command_descriptor_from_user_input'

module ToyRobot
  module Cli
    module Builders
      describe CommandDescriptorFromUserInput do
        subject(:builder) { described_class.new(user_input) }

        describe '#build' do
          subject(:build) { builder.build }

          context 'when user_input is empty' do
            let(:user_input) { '' }

            it 'return a failure' do
              expect(build.failure)
                .to match(/Please enter a valid command./)
            end
          end

          context 'when user_input is not empty' do
            context 'when command_identifier is valid' do
              context 'when arguments are valid' do
                context 'when PLACE command' do
                  let(:user_input) { 'PLACE 2,2,WEST' }
                  let(:place_command_argument_from_user_input) { instance_double(PlaceCommandArgumentFromUserInput) }
                  let(:place_command_argument) { instance_double(ValueObjects::PlaceCommandArgument) }
                  let(:command_descriptor) { instance_double(ValueObjects::CommandDescriptor) }

                  it 'returns a command_descriptor', :aggregate_failures do
                    expect(PlaceCommandArgumentFromUserInput)
                      .to receive(:new)
                      .with('2,2,WEST')
                      .and_return(place_command_argument_from_user_input)
                    expect(place_command_argument_from_user_input)
                      .to receive(:build)
                      .and_return(Dry::Monads::Success(place_command_argument))
                    expect(ValueObjects::CommandDescriptor)
                      .to receive(:new)
                      .with(identifier: 'PLACE', argument: place_command_argument)
                      .and_return(command_descriptor)

                    expect(build).to be_a_success_with_value(command_descriptor)
                  end
                end

                context 'when any other command' do
                  let(:user_input) { 'RIGHT' }
                  let(:command_descriptor) { instance_double(ValueObjects::CommandDescriptor) }

                  it 'returns a command_descriptor', :aggregate_failures do
                    expect(ValueObjects::CommandDescriptor)
                      .to receive(:new)
                      .with(identifier: 'RIGHT', argument: nil)
                      .and_return(command_descriptor)

                    expect(build).to be_a_success_with_value(command_descriptor)
                  end
                end
              end

              context 'when arguments are not valid' do
                context 'when PLACE command' do
                  let(:user_input) { 'PLACE 2,y,RIGHT' }
                  let(:place_command_argument_from_user_input) { instance_double(PlaceCommandArgumentFromUserInput) }

                  it 'returns a failure', :aggregate_failures do
                    expect(PlaceCommandArgumentFromUserInput)
                      .to receive(:new)
                      .with('2,y,RIGHT')
                      .and_return(place_command_argument_from_user_input)
                    expect(place_command_argument_from_user_input)
                      .to receive(:build)
                      .and_return(Dry::Monads::Failure('Invalid Argument.'))

                    expect(build).to be_a_failure_with_value('Invalid Argument.')
                  end
                end

                context 'when any other command' do
                  let(:user_input) { 'MOVE argument' }

                  it 'returns a failure', :aggregate_failures do
                    expect(build)
                      .to be_a_failure_with_value("Command: 'MOVE' does not take argument(s).")
                  end
                end
              end
            end

            context 'when command_identifier is not valid' do
              let(:user_input) { 'COMMAND' }

              it 'returns a failure' do
                expect(build.failure).to match(/Unknown command: 'COMMAND'/)
              end
            end
          end
        end
      end
    end
  end
end
