require 'stewfinder/version'
require 'yaml'

class Stewfinder
  def initialize(filename)
    @name = filename
  end

  def find
    stewards = get_stewards

    puts 'Stewards for this file:'
    if stewards.empty?
      puts 'None'
    else
      puts ' - ' + stewards.uniq.sort.join("\n - ")
    end
  end

  private

  def get_stewfiles
    filename = @name.split('/')
    stewfiles = []
    while filename.size > 1
      filename.delete_at(-1)
      files = `ls #{filename.join('/')}`.split("\n").inspect

      next unless files.include?('stewards.yml')
      stewfiles << "#{filename.join('/')}/stewards.yml"
    end

    stewfiles
  end

  def get_stewards
    stewards = []
    stewfiles = get_stewfiles
    stewfiles.each do |x|
      steward_hash = YAML.load(`cat #{x}`)
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
            puts "Invalid Format: #{s.inspect} in file #{x}"
          end
        else
          puts "Invalid Format: #{s.inspect} in file #{x}"
        end
      end
    end

    stewards
  end
end
