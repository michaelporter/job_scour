class LinkParser
  def initialize(options = {})
    @path_actions = options[:path_actions] || ['jobs', 'careers', 'about', 'team']
  end

  def collect_test_paths(url)
    try_links = []

    if url =~ /\w+\/\w+/
      try_links << url
    else
      @path_actions.each do |path_action|
        path_action = "/" + path_action unless url[-1] == '/'
        try_links << url + path_action
      end
    end

    try_links
  end

  def get_valid_links(links, aggregator)
    links.dup.keep_if {|link| !aggregator.ignore_link_text.include?(link.text) }
  end
end
