require 'yaml'

module Stewfinder
  class Finder
    def initialize(filename)
      raise StandardError, "Invalid file #{filename}" unless File.exist?(filename)
      @name = filename
    end

    def find
      get_stewards.uniq
    end

    def print_stewards(sort)
      stewards = find

      str = "Stewards for #{@name}:\n"
      if stewards.empty?
        str += 'None'
      else
        stewards = stewards.sort! if sort
        str += ' - ' + stewards.join("\n - ")
      end

      puts str
    end

    private

    def get_stewfiles
      stewfiles = []
      cur_path = Pathname(@name)
      prev_path = nil
      while cur_path != prev_path
        stewfiles << File.join(cur_path, 'stewards.yml') if File.exist?(File.join(cur_path, 'stewards.yml'))
        prev_path = cur_path
        cur_path = cur_path.split.first
      end
      stewfiles
    end

    def get_stewards
      stewards = []
      stewfiles = get_stewfiles
      stewfiles.each do |file|
        steward_hash = YAML.load_file(file)
        next unless steward_hash

        steward_hash['stewards'].each do |s|
          case s
          when String
            stewards << s
          when Hash
            begin
              if [s['include']].flatten.any? { |i| File.fnmatch?(i.to_s, @name) } &&
                 [s['exclude']].flatten.none? { |i| File.fnmatch?(i.to_s, @name) }
                stewards << s['github_username']
              end
            rescue
              puts "Invalid Format: #{s.inspect} in file #{file}"
            end
          else
            puts "Invalid Format: #{s.inspect} in file #{file}"
          end
        end
      end

      stewards
    end
  end
end
