require 'test_helper'

module Stewfinder
  class FinderTest < MiniTest::Test
    def test_initialize__file_does_not_exist
      File.expects(:exist?).returns(false)

      assert_raises StandardError do
        Finder.new('not a file lol')
      end
    end

    def test_find
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns(loaded_stewfile)

      finder = Finder.new('/home/test/git/stewfinder')

      assert_equal %w(test2 test1), finder.find
    end

    def test_find_relative_file
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns(loaded_stewfile)

      finder = Finder.new('/home/test/git/stewfinder/relative_file')

      assert_equal %w(test2 test1 relative_file), finder.find
    end

    def test_find__with_regex
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns(loaded_stewfile)

      finder = Finder.new('/home/test/git/stewfinder/regex.rb')

      assert_equal %w(test2 test1 test_regex1 test_regex2), finder.find
    end

    def test_find__handles_bad_syntax
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns('stewards' => ['test1', 1])
      STDOUT.expects(:puts).with('Invalid Format: 1 in file /stewards.yml')

      finder = Finder.new('/')

      assert_equal %w(test1), finder.find
    end

    def test_find__does_not_load_nonexistant_files
      File.stubs(:exist?).returns(false)
      File.expects(:exist?)
          .with(any_of('/home/test/stewards.yml', '/home/test/git/stewfinder/test/finder_test.rb'))
          .returns(true).twice
      YAML.expects(:load_file).returns('stewards' => ['test1'])

      finder = Finder.new('/home/test/git/stewfinder/test/finder_test.rb')

      assert_equal ['test1'], finder.find
    end

    def test_find__no_stewards
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns('stewards' => [])

      finder = Finder.new('/home/test/git/stewfinder')

      assert_equal [], finder.find
    end

    def test_find__fnmatch_raises_error
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns('stewards' => [{ 'github_username' => 'test_regex2', 'include' => '*regex*' }])
      STDOUT.expects(:puts).with do |*args|
        args.first.include?('Invalid Format')
      end

      File.expects(:fnmatch?).raises(StandardError)

      finder = Finder.new('/')

      finder.find
    end

    def test_print_stewards__unsorted
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns(loaded_stewfile)
      STDOUT.expects(:puts).with("Stewards for /home/test/git/stewfinder:\n - test2\n - test1")

      finder = Finder.new('/home/test/git/stewfinder')

      finder.print_stewards(false)
    end

    def test_print_stewards__sorted
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns(loaded_stewfile)
      STDOUT.expects(:puts).with("Stewards for /home/test/git/stewfinder:\n - test1\n - test2")

      finder = Finder.new('/home/test/git/stewfinder')

      finder.print_stewards(true)
    end

    def test_print_stewards__no_stewards
      File.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).returns('stewards' => [])
      STDOUT.expects(:puts).with("Stewards for /home/test/git/stewfinder:\nNone")

      finder = Finder.new('/home/test/git/stewfinder')

      finder.print_stewards(false)
    end

    private

    def loaded_stewfile
      { 'stewards' => [
        'test2',
        'test1',
        { 'github_username' => 'test_regex1', 'include' => ['*regex*'] },
        { 'github_username' => 'test_regex2', 'include' => '*regex*' },
        { 'github_username' => 'relative_file', 'include' => 'relative_file' }
      ] }
    end
  end
end
