class CurlBrowser < Browser
  def scour_aggregator(aggregator)
    @aggregator_url = aggregator.url

    get_url(@aggregator_url) do |page|
      scour_page(page, aggregator)
    end

    return @found_jobs
  end

  private

  def find_keywords(job_link)
    get_url(job_link) do |jobs_page|
      super(jobs_page, job_link)
    end
  end

  def get_url(url)
    unless url.gsub(" ", "").empty?
      result = `curl -f -s 2 #{url}`
      yield result if block_given?
    end
  end

  def scour_page(page, aggregator)
    page = Nokogiri::HTML(page)
    links = page.css("a")
    unique_links = get_valid_links(links, aggregator)
    progress_bar = new_progressbar(
      :title => page.title,
      :total => unique_links.length
    )

    unique_links.each do |link|
      if link
        url = link.attributes["href"].value

        create_links(url) do |composed_link|
          find_keywords(composed_link)
        end
      end

        progress_bar.increment
    end
  end

  def get_valid_links(links, aggregator)
    valid_links = links.dup.map {|link| !aggregator.ignore_link_text.include?(link.text) ? link : nil }
    valid_links.compact

    valid_links
  end
end
