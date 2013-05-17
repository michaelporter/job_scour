class MechanizeBrowser < Browser
  def scour_aggregator(aggregator)
    @aggregator_url = aggregator.url

    get_url(@aggregator_url) do |page|
      scour_page(page, aggregator)
    end

    return @found_jobs
  end

  def scour_page(page, aggregator)
    links = page.links
    unique_links = get_valid_links(links, aggregator)
    progress_bar = new_progressbar(
      :title => page.title,
      :total => unique_links.length
    )

    unique_links.each_with_index do |link, index|
      @job_found = false

      unless last_link?(links, index)
        create_links(link.href) do |composed_link|
          find_keywords(composed_link) rescue next
        end
      end

      progress_bar.increment
    end
  end

  private

  def last_link?(links, index)
    index == links.length - 1
  end

  def find_keywords(job_link)
    get_url(job_link) do |jobs_page|
      @pages_checked << jobs_page

      super(jobs_page.body, job_link)
    end
  end
  
  def get_url(url)
    unless url.gsub(" ", "").empty?
      Mechanize.start do |agent|
        puts "getting #{url}"
        agent.get(url)
        yield agent.page if block_given?
      end
    end
  end
end

