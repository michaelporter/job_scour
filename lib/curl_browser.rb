class CurlBrowser < Browser
  private

  def curl(url)
    `curl -f -s 2 #{url}`
  end

  def browse_to_url(url)
    url.gsub(" ", "").empty? ? " " : curl(url)
  end

  def scour_page(page)
    page = Nokogiri::HTML(page)
    super(page)
  end

  def get_links(page)
    page.css("a")
  end

  def get_url_from_link(link)
    link.attributes["href"].value
  end
end
