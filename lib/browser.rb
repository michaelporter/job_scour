class Browser
  def initialize(options = {})
    @found_jobs = []
    @keywords = options[:keywords] || "ruby, rails"
    @link_parser = LinkParser.new
    @url_validator = UrlValidator.new
  end

  private

  def follow_link(url, &block)
    if url_valid?(url)
      test_paths = @link_parser.collect_test_paths(url)

      not_found_in = 0
      test_paths.each do |test_path|
        if url_valid?(test_path)
          yield test_path if block_given?
        end
      end
    end
  end

  def keyword_regex
    Regexp.new(@keywords.split(", ").join("|"), "i")
  end

  def get_page(page)
    raise NotImplementedError
  end

  def new_progress_bar(options = {})
    total = options[:total] || 100
    title = options[:title] || ''
    format = options[:format] || "%t |%B| %p%%"

    p = ProgressBar.create(:total => total, :title => title, :length => 80, :format => format)
  end

  def test_page_for_keywords(page_html, url)
    if page_contains_keywords?(page_html)
      @found_jobs << url
    end
  end

  def page_contains_keywords?(page_content)
    page_content =~ keyword_regex
  end

  def url_valid?(url)
    @url_validator.url_valid(url, @aggregator.url)
  end
end

