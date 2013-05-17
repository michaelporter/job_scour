require 'mechanize'
require 'ruby-progressbar'

class Browser
  def initialize(options = {})
    @keywords = options[:keywords] || "ruby, rails"
    @path_actions = options[:path_actions] || ['jobs', 'careers', 'about', 'team']

    @found_jobs = []
    @no_result_pages = []
    @pages_checked = []
  end

  private

  def create_links(url, &block)
    unless url_invalid?(url)
      try_links = collect_links_to_try(url)

      not_found_in = 0
      try_links.each do |try_link|
        unless url_invalid?(try_link)
          yield try_link if block_given?

          not_found_in += 1 unless @job_found
        end
      end

      if not_found_in == try_links.length - 1
        @no_result_pages << url
      end
    end
  end

  def collect_links_to_try(url)
    try_links = []

    if url =~ /\w+\/\w+/
      try_links << url
    else
      @path_actions.each do |path_action|
        path_action = "/" + path_action unless url[-1] == '/'
        try_links << url + path_action
      end
    end

    try_links
  end

  def find_keywords(page_html, url)
    if page_html =~ Regexp.new(@keywords.split(", ").join("|"), "i")
      @found_jobs << url
      @job_found = true
    end

  rescue
  end

  def get_page(page)
    raise NotImplementedError
  end
  
  def get_valid_links(links, aggregator)
    links.dup.keep_if {|link| !aggregator.ignore_link_text.include?(link.text) }
  end

  def new_progressbar(options = {})
    total = options[:total] || 100
    title = options[:title] || ''
    format = options[:format] || "%t |%B| %p%%"

    ProgressBar.create(:total => total, :title => title, :length => 80, :format => format)
  end

  def url_invalid?(url)
    url =~ /mailto|#{Regexp.quote(@aggregator_url)}/i || !(url =~ /http(s)?\:\/\//)
  end
end

