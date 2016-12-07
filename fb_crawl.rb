class FbCrawl
  attr_accessor :start_url, :browser, :csv, :main_url, :fb_login, :fb_password

  def initialize(fb_login, fb_password)
    @start_url = 'https://www.facebook.com/fb_name_id/movies?lst=100007310670892%3A100007310670892%3A1481069345'
    @main_url = 'https://www.facebook.com/'
    @browser = Watir::Browser.new :firefox,
               :http_client => Selenium::WebDriver::Remote::Http::Default.new

    @csv = CSV.open("csvs/fb_search#{Time.now.strftime('%Y%m%d_%H%M%S')}.csv", 'wb',
                    headers: 'book_title',
                    write_headers: true)
    @fb_login = fb_login
    @fb_password = fb_password
  end

  def login
    browser.goto start_url

    browser.text_field(id: 'email').set fb_login
    browser.text_field(id: 'pass').set fb_password
    browser.cookies.add("random_session","1", { expires: 10.days.from_now })
    sleep 2
    browser.element(css: 'input[type=submit]').click
  end

  def execute
    login

    puts 'loading...'
    sleep 5
    browser.execute_script("window.scrollBy(0,400)")
    puts 'scrolling...'

    puts 'loading books...'
    sleep 3
    page = Nokogiri::HTML.parse(browser.html)

    book_titles = page.css("div#pagelet_timeline_medley_books a._gx7")
    book_titles.each do |title|
      csv << [ title.text.strip ]
    end

    browser.close
    csv.close
  end
end
