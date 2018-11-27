# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'pry'

path = File.expand_path(__dir__)
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "lib"))
Dir.glob("#{path}/lib/**/*.rake").each { |f| load f }

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task(:default).clear
task default: %i[rubocop spec]
