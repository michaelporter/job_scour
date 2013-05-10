#!/usr/bin/env ruby

require_relative 'mechanize_controller.rb'
require_relative 'job_aggregator.rb'
require_relative 'made_in_nyc.rb'

job_aggregators = []
job_aggregators << MadeInNyc.new

jobs = []
job_aggregators.each do |aggregator|
  puts aggregator.inspect
  found_jobs = aggregator.find_jobs
  jobs += found_jobs
end

STDOUT.write jobs.join("\n---------\n")

