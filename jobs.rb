#!/usr/bin/env ruby

require 'mechanize'

class JobFinder
  def self.new_page(page)
    Mechanize.start do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.get(page)

      yield a.page
    end
  end
end

jobs = []

made_in_nyc = JobFinder.new_page("http://nytm.org/made-in-nyc")

path_prefixes = ['', '/site']
path_actions = ['/jobs', '/careers', '/about', '/team']

made_in_nyc.links.each do |link|
  path_prefixes.each do |path_prefix|
    path_actions.each do |path_action|
      job_link = link.href + path_prefix + path_action
      begin
        p = JobFinder.new_page(job_link)
        
        if p.body =~ /ruby|rails/i
          jobs << job_link
        end
      rescue
        next
      end
    end
  end
end

STDOUT.write jobs.join("\n---------\n")

