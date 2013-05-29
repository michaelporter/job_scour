require_relative 'test_helper.rb'

class UrlValidatorTest < Test::Unit::TestCase 
  def setup
    @aggregator_url = "www.aggregator.com"
    @url_validator = UrlValidator.new
  end

  def test_url_valid?
    test_url = "https://www.duckduckgo.com"
    @url_validator.expects(:url_does_not_have_invalid_references).with(test_url, [@aggregator_url]).returns(true)
    @url_validator.expects(:url_has_http).with(test_url).returns(true)

    assert_equal true, @url_validator.url_valid?(test_url, @aggregator_url)
  end

  def test_url_has_http
    valid_test_url = "https://www.duckduckgo.com"
    invalid_test_url = "www.duckduckgo.com"

    assert_equal true, @url_validator.send(:url_has_http, valid_test_url)
    assert_equal false , @url_validator.send(:url_has_http, invalid_test_url)
  end

  def test_url_does_not_have_invalid_references
    valid_test_url = "www.duckduckgo.com"
    invalid_test_url = "mailto:duckduckgo.com"

    assert_equal true, @url_validator.send(:url_does_not_have_invalid_references, valid_test_url, @aggregator_url)
    assert_equal false , @url_validator.send(:url_does_not_have_invalid_references, invalid_test_url, @aggregator_url)
    assert_equal false , @url_validator.send(:url_does_not_have_invalid_references, @aggregator_url, @aggregator_url)
  end

  def test_url_does_not_have_invalid_references_nil_passed
    valid_test_url = "www.duckduckgo.com"
    invalid_test_url = "mailto:duckduckgo.com"

    assert_equal true, @url_validator.send(:url_does_not_have_invalid_references, valid_test_url)
    assert_equal true , @url_validator.send(:url_does_not_have_invalid_references, @aggregator_url)
    assert_equal false , @url_validator.send(:url_does_not_have_invalid_references, invalid_test_url)
  end
end
