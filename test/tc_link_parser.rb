require_relative 'test_helper.rb'

class LinkParserTest < Test::Unit::TestCase
  def setup
    @link_parser = LinkParser.new
    @default_path_actions = ['jobs', 'careers', 'about', 'team'] 
    @test_url = "https://www.duckduckgo.com"

    @aggregator = JobAggregator.new
    @aggregator.instance_variable_set "@ignore_link_text", ["(hiring)"]
  end

  def test_path_actions_default
    assert_equal @default_path_actions, @link_parser.instance_variable_get("@path_actions")
  end

  def test_collect_test_paths
    assert_instance_of Array, @link_parser.collect_test_paths(@test_url)
  end

  def test_get_valid_links
    test_link = mock()
    test_link.stubs(:text).returns("(hiring)")
    test_links = [test_link]

    result = @link_parser.get_valid_links(test_links, @aggregator)
    assert_instance_of Array, result
    assert_equal [], result
  end
end

