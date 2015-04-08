class Browser
  def initialize(options = {})
    @found_jobs = []
    @keywords = options[:keywords] || "product"
    @link_parser = LinkParser.new
    @url_validator = UrlValidator.new

    ARGV[0] ? @num_pages = ARGV[0].to_i : @num_pages = 1
  end

  def scour_aggregator(aggregator)
    @aggregator = aggregator

    (1..@num_pages).each do |page_id|
      @aggregator.url = "https://nytm.org/made?list=true&page=#{page_id}"
      puts "Page #{page_id}"
      page = browse_to_url(@aggregator.url)
      scour_page(page)
    end

    @found_jobs
  end

  private

  def browse_to_url(url)
    raise NotImplementedError
  end

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

  def get_links
    raise NotImplementedError
  end

  def keyword_regex
    Regexp.new(@keywords.split(", ").join("|"), "i")
  end

  def new_progress_bar(options = {})
    total = options[:total] || 100
    title = options[:title] || ''
    format = options[:format] || "%t |%B| %p%%"

    p = ProgressBar.create(:total => total, :title => title, :length => 80, :format => format)
  end

  def test_page_for_keywords(page_html, url)
    if page_contains_keywords?(page_html)
        puts "Found Match at #{url}"
      @found_jobs << url
    end
  end

  def page_contains_keywords?(page_content)
    page_content =~ keyword_regex
  end

  def scour_page(page)
    links = get_links(page)
    unique_links = @link_parser.get_valid_links(links.to_a, @aggregator)
    progress_bar = new_progress_bar(
      :title => page.title,
      :total => unique_links.length
    )

    unique_links.each do |link|
      if link
        follow_link(get_url_from_link(link)) do |composed_link|
          test_page_for_keywords(browse_to_url(composed_link), composed_link) rescue next
        end
      end

      progress_bar.increment
    end
  end

  def unique_links(link)
    raise NotImplementedError
  end

  def url_valid?(url)
    @url_validator.url_valid?(url, @aggregator.url)
  end
end

