# frozen_string_literal: true

require 'toy_robot/cli/repl'

module ToyRobot
  module Cli
    describe Repl do
      subject(:repl) { described_class.new(input_handler) }

      let(:input_handler) { instance_double(InputHandler) }

      describe '#initialize' do
        it 'prints intro message on initialization' do
          expect { repl }.to output(Constants::INTRO_TEXT).to_stdout
        end
      end

      describe '#start' do
        subject(:start) { repl.start }

        let(:line) { 'COMMAND' }

        context 'when user interrupt' do
          before do
            expect(Readline)
              .to receive(:readline)
              .with('> ', true)
              .and_raise(Interrupt)
          end

          it 'displays exit message' do
            allow(Kernel).to receive(:exit)
            expect { start }
              .to output(/Ctrl-C interrupt detected.*Exiting.*Thanks.*Toy Robot Simulation/).to_stdout
          end

          it 'exits the repl' do
            expect { start }.to raise_error(SystemExit)
          end
        end

        context 'when user does not interrupt the program' do
          before do
            expect(Readline)
              .to receive(:readline)
              .with('> ', true)
              .and_return(line)
          end

          context 'when user enters quit command' do
            let(:line) { 'quit' }

            it 'exits the repl' do
              expect { start }.to raise_error(SystemExit)
            end
          end

          context 'when user enters any other command' do
            context 'when input handler does not raise exception' do
              before do
                expect(input_handler)
                  .to receive(:handle_input)
                  .with('COMMAND')
              end

              it 'asks for next command' do
                expect(Readline)
                  .to receive(:readline)
                  .with('> ', true)
                  .and_return('quit') # to quit on next iteration, otherwise it will again wait for command

                expect { start }.to raise_error(SystemExit)
              end
            end

            context 'when input handler raises exception' do
              before do
                expect(input_handler)
                  .to receive(:handle_input)
                  .with(line)
                  .and_raise(StandardError.new('ERROR'))
              end

              it 'prints out error message' do
                allow(Kernel).to receive(:exit)
                expect { start }
                  .to output(/Something went wrong.*Backtrace/).to_stdout
              end

              it 'exits repl' do
                expect { start }
                  .to raise_error(SystemExit)
              end
            end
          end
        end
      end
    end
  end
end
