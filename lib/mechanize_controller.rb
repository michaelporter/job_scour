require 'mechanize'

class MechanizeController
  def new_page(page)
    unless page.gsub(" ", "").empty?
      Mechanize.start do |agent|
        agent.get(page)
        yield agent.page if block_given?
      end
    end
  end
end
