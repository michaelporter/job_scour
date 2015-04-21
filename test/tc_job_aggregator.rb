require_relative 'test_helper.rb'

class JobAggregatorTest < Test::Unit::TestCase
  def setup
    @job_aggregator = JobAggregator.new
  end

  def test_url_attribute
    assert_respond_to @job_aggregator, :url
  end

  def test_url_attribute_default
    assert_equal '', @job_aggregator.url
  end

  def test_ignore_link_test_attribute
    assert_respond_to @job_aggregator, :ignore_link_text
  end

  def test_ignore_link_test_attribute_default
    assert_equal [], @job_aggregator.ignore_link_text
  end
end

class MadeInNycTest < Test::Unit::TestCase
  def setup
    @made_in_nyc = MadeInNyc.new
  end

  def test_inherits_from_job_aggregator
    assert_kind_of JobAggregator, @made_in_nyc
  end

  def test_url_attribute_default
    assert_equal 'https://nytm.org/made?list=true', @made_in_nyc.url
  end

  def test_ignore_link_test_attribute
    assert_respond_to @made_in_nyc, :ignore_link_text
  end

  def test_ignore_link_test_attribute_default
    assert_equal ['(hiring)'], @made_in_nyc.ignore_link_text
  end
end
