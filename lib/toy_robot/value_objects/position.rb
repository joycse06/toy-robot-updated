# frozen_string_literal: true

require 'dry-struct'
require 'toy_robot/types'

module ToyRobot
  module ValueObjects
    class Position < ::Dry::Struct::Value
      attribute :x, Types::XAxisValue
      attribute :y, Types::YAxisValue
    end
  end
end
