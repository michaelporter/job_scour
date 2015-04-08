class JobAggregator
  def initialize
    @ignore_link_text ||= []
    @url ||= ''
  end

  attr_reader :ignore_link_text
  attr_accessor :url
end

class MadeInNyc < JobAggregator
  def initialize
    @url = "https://nytm.org/made?list=true"
    @ignore_link_text = ['(hiring)']

    super
  end
end
