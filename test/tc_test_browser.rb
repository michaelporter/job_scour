require_relative 'test_helper.rb'

class TestBrowser < Test::Unit::TestCase
  def setup
    @keywords = 'ruby, rails'
    @keywords2 = 'php, java'
    @browser = Browser.new(:keywords => @keywords)
  end

  def test_follow_link
    test_url = "https://www.duckduckgo.com"
    @link_parser = mock()
    @link_parser.stubs(:collect_test_paths).returns(['/about', '/jobs'])
    @browser.stubs(:url_valid?).returns(true)
    @browser.instance_variable_set "@link_parser", @link_parser

    assert_nothing_raised do
      @browser.send(:follow_link, test_url)
    end
  end

  ## Keywords
  
  def test_default_keywords
    assert_equal @keywords, @browser.instance_variable_get('@keywords')
  end

  def test_user_given_keywords
    @browser2 = Browser.new(:keywords => @keywords2)
    assert_equal @keywords2, @browser2.instance_variable_get('@keywords')
  end

  def test_keywords_regex
    assert_instance_of Regexp, @browser.send(:keyword_regex)
    assert_match @browser.send(:keyword_regex), @keywords
    assert_no_match @browser.send(:keyword_regex), @keywords2
  end

  def test_page_contains_keywords
    page_html = "<html>ruby developers</html>"
    assert_not_nil @browser.send(:page_contains_keywords?, page_html)
  end

  def test_test_page_for_keywords_case_insensitive
    page_html = "<html>Ruby developers</html>"
    assert_not_nil @browser.send(:page_contains_keywords?, page_html)
  end

  def test_get_page
    assert_raise NotImplementedError do
      @browser.send(:get_page, "https://www.duckduckgo.com")
    end
  end

  def test_new_progressbar
    assert_instance_of ProgressBar::Base, @browser.send(:new_progress_bar)
    assert_instance_of ProgressBar::Base, @browser.send(:new_progress_bar, {:title => "Test Bar", :total => 120})
  end
end

