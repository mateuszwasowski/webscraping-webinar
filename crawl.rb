class Crawl
  attr_accessor :start_url, :browser, :csv, :main_url

  def initialize
    @start_url = 'http://webscraper.io/test-sites/e-commerce/allinone/'
    @main_url = 'http://webscraper.io/'
    @browser = Watir::Browser.new :firefox,
               :http_client => Selenium::WebDriver::Remote::Http::Default.new

    @csv = CSV.open("csvs/crawl_search#{Time.now.strftime('%Y%m%d_%H%M%S')}.csv", 'wb',
                    headers: 'category, subcategory, name',
                    write_headers: true)
  end

  def execute
    browser.goto start_url
    page = Nokogiri::HTML.parse(browser.html)

    categories = page.css("a.category-link")

    categories.each do |category|
      cat_name = category.text.strip
      browser.goto main_url + category.values.first
      category_page = Nokogiri::HTML.parse(browser.html)

      subcategories = category_page.css("a.subcategory-link")

      subcategories.each do |subcategory|
        sub_name = subcategory.text.strip
        browser.goto main_url + subcategory.values.first
        subcategory_page = Nokogiri::HTML.parse(browser.html)

        products = subcategory_page.css("div.thumbnail a")
        products.each do |product|
          csv << [
            cat_name,
            sub_name,
            product.text
          ]
        end
      end
    end

    browser.close
    csv.close
  end
end
