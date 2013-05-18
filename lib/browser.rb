require 'mechanize'
require 'ruby-progressbar'

class Browser
  def initialize(options = {})
    @keywords = options[:keywords] || "ruby, rails"

    @link_parser = LinkParser.new

    @found_jobs = []
    @no_result_pages = []
  end

  private

  def follow_link(url, &block)
    unless url_invalid?(url)
      test_paths = @link_parser.collect_test_paths(url)

      not_found_in = 0
      test_paths.each do |test_path|
        unless url_invalid?(test_path)
          yield test_path if block_given?

          not_found_in += 1 unless @job_found
        end
      end

      if not_found_in == test_paths.length - 1
        @no_result_pages << url
      end
    end
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

