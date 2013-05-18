class JobAggregator
  def initialize
    @ignore_link_text ||= []
    @url ||= ''
  end

  attr_reader :url, :ignore_link_text
end

class MadeInNyc < JobAggregator
  def initialize
    @url = "http://nytm.org/made-in-nyc"
    @ignore_link_text = ['(hiring)']

    super
  end
end
