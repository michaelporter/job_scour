class UrlValidator
  def url_valid?(url, *invalid_references)
    url_does_not_have_invalid_references(url, invalid_references) && url_has_http(url)
  end

  private

  def url_does_not_have_invalid_references(url, *invalid_references)
    invalid_references = invalid_references.flatten.push "mailto"
    (url =~ /#{invalid_references.join("|")}/i).nil? ? true : false
  end

  def url_has_http(url)
    (url =~ /http(s)?\:\/\//i).nil? ? false : true
  end
end
