require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
  SimpleCov.coverage_dir(dir)
end

SimpleCov.minimum_coverage(100)
SimpleCov.start

require 'stewfinder'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'pathname'
