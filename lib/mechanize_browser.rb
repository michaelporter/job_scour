class MechanizeBrowser < Browser
  def scour_page(page)
    super(page)
  end

  private

  def browse_to_url(url)
    page = " "
    unless url.gsub(" ", "").empty?
      Mechanize.start do |agent|
        agent.get(url)
        page = agent.page
      end
    end

    page || " "
  end

  def get_links(page)
    page.links
  end

  def get_url_from_link(link)
    link.href
  end
end

