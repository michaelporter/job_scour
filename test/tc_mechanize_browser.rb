require_relative 'test_helper.rb'

class MechanizeBrowserTest < Test::Unit::TestCase
  def setup
    @mechanize_browser = MechanizeBrowser.new
    @test_html = "<html><head><body>Hello!<a href='https://www.duckduckgo.com'>Duck Duck Go</a></body></head></html>"
    @test_url = "https://www.duckduckgo.com"
    @test_links = [
      "https://www.duckduckgo.com/jobs"
    ]
  end

  def test_browse_to_url
    Mechanize.expects(:start)
    assert_nothing_raised { @mechanize_browser.send(:browse_to_url, @test_url) }
  end

  def get_links
    @test_html.expects(:links).returns(@test_links)
    assert_equal @test_links, @mechanize_browser.send(:get_links, @test_html)
  end

  def get_url_from_link
    test_link = mock()
    test_link.stubs(:url).returns(@test_links.first)
    assert_equal @test_links.first, @mechanize_browser.send(:get_url_from_link, test_link)
  end
end

