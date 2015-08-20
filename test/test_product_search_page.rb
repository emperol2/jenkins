require 'test/unit'
require 'rubygems'
require 'selenium-webdriver'


module Test
  class TestProductSearchPage < Test::Unit::TestCase

    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @driver = Selenium::WebDriver.for :phantomjs, :http_client => client
      @driver.navigate.to('http://www.bk.com/search')
      #@driver.navigate.to('http://originstg.bk.com/search')
      @driver.manage.timeouts.implicit_wait = 70
      @wait = Selenium::WebDriver::Wait.new :timeout => 25
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def test_product_search_found
      @driver.find_element(:css, '#edit-keys-3').send_keys('burger')
      @driver.find_element(:css, '#search-api-page-search-form > div > div > button').click
      sleep 2
      assert @driver.title.include?('Search')
      resultList = @driver.find_elements(:css, '.itemsList li')
      resultList.each do |r|
        htmlResults = r.attribute('innerHTML')
        assert((htmlResults.match /burger/i), "The result in the table should contain 'burger'")
      end
      resultsText = @driver.find_element(:css, 'div.resultsNo').text
      resultsSplit = resultsText.split(/[a-zA-Z ]/)
      getResultNumber = resultsSplit[12]
      assert(getResultNumber.to_i > 0, 'Search result number should greater than 0')
    end

    def test_product_search_not_found
      @driver.find_element(:css, '#edit-keys-3').send_keys('aaaaaaaaaaa')
      @driver.find_element(:css, '#search-api-page-search-form > div > div > button').click
      sleep 2
      assert(@driver.title.include?('Search'))
      assert((element_present?(:css, '.itemsList li') == false), 'Page title is incorrect')
      assert((@driver.find_element(:css, 'h3.sectionTitle').text.match /aaaaaaaaaaa/i), 'Title tag is incorrect')
      assert((@driver.find_element(:css, 'div.resultsNo').text.match /No/i), 'Search result number is incorrect')
    end

    def element_present?(how, what)
      found = @driver.find_element(how => what)
      if found
        true # return true if this element is found
      else
        false # return false if this element is not found
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError # catch if NoSuchElementError appears
      false
    end

    def teardown
      # Do nothing
      @driver.quit
    end

  end
end
