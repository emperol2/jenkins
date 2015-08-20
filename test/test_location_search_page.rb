require 'test/unit'
require 'rubygems'
require 'selenium-webdriver'


module Test
  class TestLocationSearchPage < Test::Unit::TestCase

    # Called before every test method runs. Can be used
    # to set up fixture information.
    def setup
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 300
      @driver = Selenium::WebDriver.for :phantomjs, :http_client => client
      @driver.navigate.to('http://www.bk.com/locations')
      #@driver.navigate.to('http://originstg.bk.com/locations')
      @driver.manage.timeouts.implicit_wait = 60
      @wait = Selenium::WebDriver::Wait.new :timeout => 25
    end

    # Called after every test method runs. Can be used to tear
    # down fixture information.

    def test_location_search_found
      @driver.navigate.to('http://www.bk.com/locations?field_geofield_distance[origin][lat]=25.7616798&field_geofield_distance[origin][lon]=-80.19179020000001')
      sleep 2
      assert @driver.title.include?('Find a Burger King near you')
      locationText = @driver.find_element(:css, '.bk-location-target').text
      locationSplit = locationText.split(/\,/)
      getLocation = locationSplit[0]
      #assert((getLocation.match /miami/i), 'the location does not match the input')

      resultsText = @driver.find_element(:css, '.bk-location-total').text
      resultsSplit = resultsText.split(/[a-zA-Z ]/)
      getResultNumber = resultsSplit[0]
      assert(getResultNumber.to_i > 0, 'Search result number should greater than 0')

      resultList = @driver.find_elements(:css, 'div.location')
      resultList.each do |r|
        p r.text
        p htmlResults = r.attribute('innerHTML')
        assert((htmlResults.match /miami/i), "The result in the table should contain 'maimi'")
      end

    end

    def test_location_search_not_found
      @driver.find_element(:css, '.locInput input').send_keys('bangkok')
      @driver.find_element(:css, 'div.locInput a').click
      sleep 2
      assert @driver.title.include?('Find a Burger King near you')
      assert((element_present?(:css, 'div.location') == false), 'Table should not shown when search not found')
      assert((@driver.find_element(:css, 'h2.sectionTitle').text.match /none found/i), 'the result should be not found')

      resultsText = @driver.find_element(:css, '.bk-location-total').text
      resultsSplit = resultsText.split(/[a-zA-Z ]/)
      getResultNumber = resultsSplit[0]
      assert(getResultNumber.to_i == 0, 'Search result number should be 0')

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