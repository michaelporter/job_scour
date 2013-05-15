require 'ruby-progressbar'

class JobAggregator
  def initialize
    @browser = Browser.new
    @found_jobs = []

    @keywords ||= ['ruby', 'rails']

    @path_actions = ['jobs', 'careers', 'about', 'team']
    @url ||= ''
  end

  def find_jobs
    @browser.new_page(@url) do |page|
      progress_bar = new_progressbar(:title => page.title, :total => page.links.length)

      page.links.shuffle.each do |link|

        @job_found= false
        create_links(link.href) do |composed_link|
          begin
            scour(composed_link)
          rescue
            next
          end
        end

        progress_bar.increment
      end
    end
    
    @found_jobs
  end

  private

  def create_links(url, &block)
    unless url_invalid?(url)
      @path_actions.each do |path_action|
        path_action = "/" + path_action unless url[-1] == '/'
        composed_link = url + path_action

        unless url_invalid?(composed_link)
          yield composed_link if block_given?
        end
      end
    end
  end

  def new_progressbar(options = {})
    total = options[:total] || 100
    title = options[:title] || ''

    ProgressBar.create(:total => total, :title => title, :length => 80)
  end

  def scour(job_link)
    unless @job_found
      @browser.new_page(job_link) do |jobs_page|
        if jobs_page.body =~ keyword_regex
          @found_jobs << job_link
          @job_found = true
        end
      end
    end
  end

  def url_invalid?(url)
    url =~ /mailto|#{Regexp.quote(@url)}/i
  end
end

