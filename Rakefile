require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  sh 'rubocop'
  t.libs << 'test'
  t.pattern = 'test/*_test.rb'
end
