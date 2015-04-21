require_relative 'test_helper.rb'

class CurlBrowserTest < Test::Unit::TestCase
  def setup
    @curl_browser = CurlBrowser.new
    @test_job_url = "https://www.duckduckgo.com/jobs"
    @test_html = "<html><head><body>Hello!<a href='https://www.duckduckgo.com'>Duck Duck Go</a></body></head></html>"

    @aggregator = mock()
    @aggregator.stubs(:url).returns("https://nytm.made-in-nyc")

    @link_parser = mock()

    @test_links = [
      "https://www.duckduckgo.com/jobs"
    ]
    
    @test_links.map! do |link|
      mock_href = mock()
      mock_href.stubs(:value).returns(link)

      mock_link = mock()
      mock_link.stubs(:attributes).returns({'href' => mock_href})

      link = mock_link
    end

    @curl_browser.instance_variable_set "@link_parser", @link_parser

    @progress_bar = mock()
    @progress_bar.stubs(:increment).returns(true)
  end

  def test_curl_browser_inherits_browser
    assert_kind_of Browser, @curl_browser
  end

  def test_scour_aggregator
    @curl_browser.expects(:browse_to_url).returns(@test_html)
    @curl_browser.expects(:scour_page).with(@test_html).returns(nil)

    assert_instance_of Array, @curl_browser.scour_aggregator(@aggregator)
  end

  def test_browse_to_url
    @curl_browser.expects(:curl).with(@test_job_url).returns(@test_html)

    assert_nothing_raised { @curl_browser.send(:browse_to_url, @test_job_url) }
  end

  def test_curl
    assert_nothing_raised { @curl_browser.send(:curl, @test_job_url) }
  end

  def test_get_links
    @test_html.expects(:css).returns(true)

    assert_not_nil @curl_browser.send(:get_links, @test_html)
  end

  def test_get_url_from_link
    assert_equal @test_job_url, @test_links.first.attributes["href"].value
  end

  def test_scour_page
    test_page = mock()
    test_page.stubs(:title).returns("Page Title")
    @link_parser.expects(:get_valid_links).returns(@test_links)
    @curl_browser.expects(:new_progress_bar).returns(@progress_bar)
    @curl_browser.stubs(:follow_link).yields(@test_links.first)
    @curl_browser.expects(:browse_to_url).returns @test_html
    @curl_browser.expects(:test_page_for_keywords).returns true

    assert_nothing_raised { @curl_browser.send(:scour_page, @test_html) }
  end
end
