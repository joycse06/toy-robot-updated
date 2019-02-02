# Toy Robot
**Toy Robot** is a Ruby `CLI` app that let users simulate the movement of a Toy Robot on a 5X5 tabletop.

# Problem Definition
The problem definition can be found at [PROBLEM.md](PROBLEM.md)

## Requirements
This app has been developed and tested with `ruby` version `2.5.3`.

  **Installation Instructions**:

### On [NixOs](https://nixos.org/) (my primary OS)
You can run `nix-shell` on the root of the project and it will install the correct version of ruby (with other required dependencies).

### On `macOS` (previously `OSX`)
Install any of the available ruby version managers e.g. [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

Then run `rbenv install 2.5.3` or `rvm install 2.5.3` to install the correct version of ruby.

Some of the ruby gem dependencies have native extensions, so make sure the system has `build tools` installed so they can be compiled (search `google` for `command line developer tools on macOS (or OSX)`).

### On any other OS
Use your operating systems manual or search on `google` on how to install a specific version of ruby on your specific OS.
[https://www.ruby-lang.org/en/downloads/](https://www.ruby-lang.org/en/downloads/) can be a good starting point.


## Usage

Install `ruby` following the installation instruction above. Then run `bin/setup` from the root of the project to set up the project (installing required gems).

Once the dependencies have been installed, run `bin/run` to start the `REPL` and then follow the instructions.

### Interpreting Commands From File

The program also supports interpreting commands from a file for convenience. Create a file with one command per line then run it like `INPUT_FILE=/path/to/commands/file bin/run`. It will interpret the file line by line if it exists and will fall back to the `REPL` if it does not.

The project includes example command files at `spec/fixtures` which can be used like `INPUT_FILE=./spec/fixtures/commands_file_with_all_valid_commands.txt bin/run` from the root of the project.

Enjoy!

## Development

Run `bundle exec rspec` to run the tests. It will generate code coverage into the `coverage` directory. You can also run `bin/console` and it will instantiate few useful objects and drop you on a `pry` console. Convenient for experimenting.

## Assumptions

* Assumed it's ok to convert the text entered by the user into uppercase

## Design Analysis

### Design Principles

* Uses domain entities and value objects to represent the core entities it works with and use `dry-types` to enforce correctness of the data it works with.
* Use dependency inject where ever applicable.
* Use builders to construct a `CommandDescriptor` so the `Simulator` can perform it's operation without worrying about invalid commands. As long as it receives an instance of the `CommandDescriptor` it can be sure that it has a valid command.
* Tries to follow `SRP` (Single Responsibility Principle) but couldn't spend enough time looking back at them after finishing it. Sometimes looking at a complete solution gives opportunities to find out modelling/design problems easily.
* Tries to use `Result` types to represent errors rather than using `exception for control flow` or passing around nils when a recoverable error occurs.
* Tries to use `CLI` as a delivery mechanism while striving to make the core of the `app` reusable with other delivery mechanisms easily (e.g. web).


### What else would I have done if I had more time?
* Implemented proper validation with `dry-schemas` to provide better error messages.
* Spent a bit more time with the data types to see if there's any low hanging refactoring that can be performed.
* Would have researched ways to write integration spec for testing `bin/run`.
* Would have spent a bit more time thinking about edge cases and had written more specs if the app was not handling any of those cases
* Though about if I should move `Entities::Robot` into `ValueObjects` namespace. Though it feels like it's an entity, It's being used as an immutable value object.
* Would have introduced a `Sum` type for the return value of the `CommandInterpreter`, something along the line of `CommandInterpreterResult = Entities::Robot | Types::Strict::String` so it could either return an updated robot or some output to return to the user (for `REPORT` command) and simulator could do the right thing based on that. (and it won't have to pry into the `command_identifier` itself, which I think is not it's responsibility).
* Would have tested the `CommandFileInterpreter` more, DRY-ed up file interpreter and `REPL` (they have a fair bit of duplication)

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). A copy of which is included in [LICENSE.txt](LICENSE.md)
