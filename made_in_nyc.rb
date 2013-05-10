class MadeInNyc < JobAggregator
  def initialize
    @url = "http://nytm.org/made-in-nyc"
    @link_selector = ""

    super
  end
end

