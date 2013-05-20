class CurlBrowser < Browser
  def scour_aggregator(aggregator)
    @aggregator_url = aggregator.url

    get_url(@aggregator_url) do |page|
      scour_page(page, aggregator)
    end

    @found_jobs
  end

  private

  def curl(url)
    `curl -f -s 2 #{url}`
  end

  def get_url(url)
    unless url.gsub(" ", "").empty?
      result = curl(url)
      yield result if block_given?
    end
  end

  def scour_page(page, aggregator)
    page = Nokogiri::HTML(page)
    links = page.css("a")
    unique_links = @link_parser.get_valid_links(links.to_a, aggregator)
    progress_bar = new_progress_bar(
      :title => page.title,
      :total => unique_links.length
    )

    unique_links.each do |link|
      if link
        url = link.attributes["href"].value

        follow_link(url) do |composed_link|
          test_page_for_keywords(composed_link)
        end
      end

      progress_bar.increment
    end
  end

  def test_page_for_keywords(job_link)
    get_url(job_link) do |jobs_page|
      super(jobs_page, job_link)
    end
  end
end
