class JobAggregator
  def initialize
    @ignore_link_text ||= []
    @urls ||= []
  end

  attr_reader :ignore_link_text
  attr_accessor :urls

  def paged_urls(config)
    url_array = []

    (1..config[:num_pages]).each do |page|
      url_array << config[:url_base] + config[:page_structure] + page.to_s
    end
    url_array
    
  end

end

class MadeInNyc < JobAggregator
  def initialize

    config = Psych::load(File.open('config.yml'))

    url_config = {
      url_base: config['aggregators']['MadeInNyc']['base_url'],
      page_structure:  config['aggregators']['MadeInNyc']['page_structure'],
      num_pages: config['aggregators']['MadeInNyc']['num_pages']
    }

    @ignore_link_text = ['(hiring)']
    
    @urls = paged_urls(url_config)

    super
  end

end
