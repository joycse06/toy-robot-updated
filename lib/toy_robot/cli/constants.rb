# frozen_string_literal: true

module ToyRobot
  module Cli
    module Constants
      INTRO_TEXT = <<~TEXT
        Welcome to Toy Robot Simulation. Place the robot into the grid and start
        moving it around. Enjoy!
      TEXT
      QUIT_COMMAND_TEXT = 'quit'
      USAGE_BANNER_TEXT = <<~TEXT
        ######################################################################
        | This program let the user simulate a robot's movement on top of a |
        | 5X5 Table (grid).                                                 |
        | Valid commands are:                                               |
        | PLACE X,Y,FACING                                                  |
        | MOVE                                                              |
        | LEFT                                                              |
        | RIGHT                                                             |
        | REPORT                                                            |
        |                                                                   |
        | You can exit anytime by typing `quit` or pressing Ctrl-C          |
        ######################################################################
      TEXT
    end
  end
end
