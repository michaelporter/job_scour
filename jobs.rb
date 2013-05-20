#!/usr/bin/env ruby

require 'ruby-progressbar'
require 'mechanize'

require_relative 'lib/link_parser.rb'
require_relative 'lib/url_validator.rb'
require_relative 'lib/browser.rb'
require_relative 'lib/mechanize_browser.rb'
require_relative 'lib/curl_browser.rb'
require_relative 'lib/job_aggregator.rb'

@browser = CurlBrowser.new(:keywords => 'ruby, rails')

job_aggregators = []
job_aggregators << MadeInNyc.new

jobs = []
job_aggregators.each do |aggregator|
  found_jobs = @browser.scour_aggregator(aggregator)

  File.open("results.txt", "w+") do |f|
    f << found_jobs.join("\n")
  end

  jobs += found_jobs
end

