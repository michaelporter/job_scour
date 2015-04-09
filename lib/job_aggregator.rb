class JobAggregator
  def initialize
    @ignore_link_text ||= []
    @url ||= ''
    @num_pages = ARGV[0] ? ARGV[0].to_i : 1

  end

  attr_reader :ignore_link_text, :num_pages
  attr_accessor :url
end

class MadeInNyc < JobAggregator
  def initialize
    @url = "https://nytm.org/made?list=true"
    @ignore_link_text = ['(hiring)']

    super
  end

  def paged_urls(pages)
    urls = []
    (1..pages).each do |page|
      urls << @url + "&page=#{page}"
    end

    urls

  end

end
