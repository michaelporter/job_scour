class MechanizeBrowser < Browser
  def scour_aggregator(aggregator)
    @aggregator_url = aggregator.url

    get_url(@aggregator_url) do |page|
      scour_page(page, aggregator)
    end

    @found_jobs
  end

  def scour_page(page, aggregator)
    links = page.links
    unique_links = @link_parser.get_valid_links(links, aggregator)
    progress_bar = new_progressbar(
      :title => page.title,
      :total => unique_links.length
    )

    unique_links.each do |link|
      @job_found = false

      follow_link(link.href) do |composed_link|
        find_keywords(composed_link) rescue next
      end

      progress_bar.increment
    end
  end

  private

  def find_keywords(job_link)
    get_url(job_link) do |jobs_page|
      super(jobs_page.body, job_link)
    end
  end
  
  def get_url(url)
    unless url.gsub(" ", "").empty?
      Mechanize.start do |agent|
        agent.get(url)
        yield agent.page if block_given?
      end
    end
  end
end

