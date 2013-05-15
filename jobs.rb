#!/usr/bin/env ruby

require_relative 'lib/browser_controller.rb'
require_relative 'lib/job_aggregator.rb'
require_relative 'lib/made_in_nyc.rb'

job_aggregators = []
job_aggregators << MadeInNyc.new

jobs = []
job_aggregators.each do |aggregator|
  found_jobs = aggregator.find_jobs
  jobs += found_jobs
end

STDOUT.write jobs.join("\n---------\n")

