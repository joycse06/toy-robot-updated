{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  ruby = pkgs.ruby_2_5;
  bundler = pkgs.bundler.override { inherit ruby; };

in pkgs.stdenv.mkDerivation {
  name = "REAToyRobotEnv";
  buildInputs = [
    readline
    ruby.devEnv
    libnotify
  ];
}
