require_relative '../config/environment'
require 'tty-prompt'
require 'pry'

cli = CommandLineInterface.new
cli.run