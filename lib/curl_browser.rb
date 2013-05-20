class CurlBrowser < Browser
  def scour_aggregator(aggregator)
    @aggregator_url = aggregator.url

    browse_to_url(@aggregator_url) do |page|
      scour_page(page, aggregator)
    end

    @found_jobs
  end

  private

  def curl(url)
    `curl -f -s 2 #{url}`
  end

  def browse_to_url(url)
    result = url.gsub(" ", "").empty? ? " " : curl(url)
  end

  def scour_page(page, aggregator)
    page = Nokogiri::HTML(page)
    super(page, aggregator)
  end

  def get_links(page)
    page.css("a")
  end

  def get_url_from_link(link)
    link.attributes["href"].value
  end
end
