require 'ruby-progressbar'

class JobAggregator
  def initialize
    @browser = Browser.new
    @found_jobs = []

    @keywords ||= 'ruby, rails'
    @no_result_pages = []

    @path_actions = ['jobs', 'careers', 'about', 'team']
    @pages_checked = []
    @url ||= ''
  end

  def get_unique_links(links)
    links.dup.keep_if {|link| link.text != "(hiring)"}
  end

  def find_jobs
    @browser.new_page(@url) do |page|
      links = page.links
      unique_links = get_unique_links(links)
      progress_bar = new_progressbar(:title => page.title, :total => unique_links.length)

      links.each_with_index do |link, index|

        @job_found = false
        unless index == links.length - 1 || links[index + 1].text == "(hiring)"
          create_links(link.href) do |composed_link|
            begin
              unless @job_found
                scour(composed_link)
              end
            rescue
              next
            end
          end

          progress_bar.increment
        end
      end
    end

    File.open("results.txt", "w+") do |f|
      f.write @found_jobs.join(",\n")
    end

    @found_jobs
  end

  private

  def collect_links_to_try(url)
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

  def create_links(url, &block)
    unless url_invalid?(url)
      try_links = collect_links_to_try(url)

      not_found_in = 0
      try_links.each do |try_link|
        unless url_invalid?(try_link)
          yield try_link if block_given?

          not_found_in += 1 unless @job_found
        end
      end

      if not_found_in == try_links.length - 1
        @no_result_pages << url
      end
    end
  end

  def keyword_regex
    Regexp.new(@keywords.split(", ").join("|"))
  end

  def new_progressbar(options = {})
    total = options[:total] || 100
    title = options[:title] || ''
    format = options[:format] || "%t |%B| %p%%"

    ProgressBar.create(:total => total, :title => title, :length => 80, :format => format)
  end

  def scour(job_link)
    @browser.new_page(job_link) do |jobs_page|
      @pages_checked << jobs_page

      if jobs_page.body =~ Regexp.new(@keywords.split(", ").join("|"), "i")
        @found_jobs << job_link
        @job_found = true
      end
    end
  end

  def url_invalid?(url)
    url =~ /mailto|#{Regexp.quote(@url)}/i || !(url =~ /http(s)?\:\/\//)
  end
end

