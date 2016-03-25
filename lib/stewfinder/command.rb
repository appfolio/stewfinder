require 'docopt'
require_relative 'finder'
require_relative 'version'

module Stewfinder
  # Provides the command line interface to Stewfinder
  class Command
    DOC = <<-DOC
    stewfinder: A tool to help discover code stewards.

    Usage:
      stewfinder [options] [PATH]
      stewfinder -h | --help
      stewfinder --version

    Options:
      --sort  Sort the output list.

    When PATH isn't provided stewfinder will use the present working directory.
    DOC
          .freeze

    def initialize
      @exit_status = 0
    end

    def run
      options = Docopt.docopt(DOC, version: VERSION)
      finder = Finder.new(File.absolute_path(options['PATH'] || Dir.pwd))
      finder.print_stewards(options['--sort'])
      @exit_status
    rescue Docopt::Exit => exc
      exit_with_status(exc.message, exc.class.usage != '')
    rescue StandardError => exc
      exit_with_status(exc.message)
    end

    private

    def exit_with_status(message, condition = true)
      puts message
      @exit_status == 0 && condition ? 1 : @exit_status
    end
  end
end
