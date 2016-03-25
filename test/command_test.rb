require 'test_helper'

module Stewfinder
  class CommandTest < MiniTest::Test
    def test_run
      finder_mock = mock
      Finder.expects(:new).with('/home/test').returns(finder_mock)
      finder_mock.expects(:print_stewards).with(false)
      cmd = Command.new
      cmd.expects(:argv).returns(['/home/test'])

      assert_equal 0, cmd.run
    end

    def test_run__sort
      finder_mock = mock
      Finder.expects(:new).with('/home/test').returns(finder_mock)
      finder_mock.expects(:print_stewards).with(true)
      cmd = Command.new
      cmd.expects(:argv).returns(['/home/test', '--sort'])

      assert_equal 0, cmd.run
    end

    def test_run__defaults_to_pwd
      Dir.expects(:pwd).returns('/current/dir')
      finder_mock = mock
      Finder.expects(:new).with('/current/dir').returns(finder_mock)
      finder_mock.expects(:print_stewards).with(false)
      cmd = Command.new
      cmd.expects(:argv).returns([])

      assert_equal 0, cmd.run
    end

    def test_run__invalid_option
      cmd = Command.new
      cmd.expects(:argv).returns(['--bryce'])
      STDOUT.expects(:puts).with("--bryce is not recognized\nUsage:\n  stewfinder [options] [PATH]\n  stewfinder -h | --help\n  stewfinder --version")

      assert_equal 1, cmd.run
    end

    def test_run__help
      cmd = Command.new
      cmd.expects(:argv).returns(['-h'])
      STDOUT.expects(:puts).with(Command::DOC)

      assert_equal 0, cmd.run
    end

    def test_run__raises
      Docopt.expects(:docopt).raises(StandardError, 'error message')
      STDOUT.expects(:puts).with('error message')

      assert_equal 1, Command.new.run
    end
  end
end
