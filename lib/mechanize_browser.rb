class MechanizeBrowser < Browser
  def scour_page(page, aggregator)
    super(page, aggregator)
  end

  private

  def browse_to_url(url)
    unless url.gsub(" ", "").empty?
      Mechanize.start do |agent|
        agent.get(url)
        yield agent.page if block_given?
      end
    end
  end

  def get_links(page)
    page.links
  end

  def get_url_from_link(link)
    link.url
  end
end

