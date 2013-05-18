#!/usr/bin/env ruby

require_relative 'lib/link_parser.rb'
require_relative 'lib/browser.rb'
require_relative 'lib/mechanize_browser.rb'
require_relative 'lib/curl_browser.rb'
require_relative 'lib/job_aggregator.rb'

#@browser = MechanizeBrowser.new(:keywords => 'ruby, rails')
@browser = CurlBrowser.new(:keywords => 'ruby, rails')

job_aggregators = []
job_aggregators << MadeInNyc.new

jobs = []
job_aggregators.each do |aggregator|
  found_jobs = @browser.scour_aggregator(aggregator)

  File.open("results.txt", "w+") do |f|
    f << "### #{aggregator.class.to_s} \n"
    f << found_jobs.join("\n")
  end

  jobs += found_jobs
end

STDOUT.write jobs.join("\n---------\n")

