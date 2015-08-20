require 'selenium-webdriver'
require 'test/unit'
#require 'phantomjs'

module Test
  class TestItemsPage < Test::Unit::TestCase

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.navigate.to('http://www.bk.com/menu')
      #@driver.navigate.to('http://originstg.bk.com/menu')
      @driver.manage.timeouts.implicit_wait = 60
      @driver.manage.timeouts.script_timeout = 30
      @wait = Selenium::WebDriver::Wait.new :timeout => 25
    end

    def teardown
      @driver.quit
    end

    def test_visible_image_items
      ary = Array.new
      itemsArray = Array.new
      nodeURL = 'http://www.bk.com/node/'
      #nodeURL = 'http://originstg.bk.com/node/'

      cagetoryList = @driver.find_elements(:css, '.food-category a')
      cagetoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |aa|
        @driver.navigate.to(aa)
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
          #p f.attribute('data-product-id')
          itemsArray.push(nodeURL+f.attribute('data-product-id'))
          #p itemsArray.size()
        end
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)
        #p a
        imgList = @driver.find_elements(:tag_name, 'img')
        imgList.each do |i|
          #puts i.attribute('src')
          # if i.attribute('typeof') != nil
          #   p i.attribute('src')
          #   res = Net::HTTP.get_response(URI(i.attribute('src')))
          #   assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          # end
          if i.attribute('src').include?('square_thumbnail') == false && i.attribute('typeof') != nil
            p i.attribute('src')
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          end
        end
      end

    end

    def test_visible_image_youmayalsolike
      ary = Array.new
      itemsArray = Array.new
      nodeURL = 'http://www.bk.com/node/'
      #nodeURL = 'http://originstg.bk.com/node/'

      cagetoryList = @driver.find_elements(:css, '.food-category a')
      cagetoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |aa|
        @driver.navigate.to(aa)
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
          #p f.attribute('data-product-id')
          itemsArray.push(nodeURL+f.attribute('data-product-id'))
          #p itemsArray.size()
        end
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)
        #p a
        imgList = @driver.find_elements(:tag_name, 'img')
        imgList.each do |i|
          #puts i.attribute('src')
          # if i.attribute('typeof') != nil
          #   p i.attribute('src')
          #   res = Net::HTTP.get_response(URI(i.attribute('src')))
          #   assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          # end
          if i.attribute('src').include?('square_thumbnail') == true
            p i.attribute('src')
            res = Net::HTTP.get_response(URI(i.attribute('src')))
            assert_equal('200', res.code, "This is error #{i.attribute('src')}")
          end
        end
      end

    end


    def test_nutrition_table
      ary = Array.new
      itemsArray = Array.new
      nodeURL = 'http://www.bk.com/node/'
      #nodeURL = 'http://originstg.bk.com/node/'

      cagetoryList = @driver.find_elements(:css, '.food-category a')
      cagetoryList.each do |c|
        ary.push(c.attribute('href'))
      end

      ary.each do |aa|
        @driver.navigate.to(aa)
        findItemLinks = @driver.find_elements(:css, 'div.col-xs-6')
        findItemLinks.each do |f|
          #p f.attribute('data-product-id')
          itemsArray.push(nodeURL+f.attribute('data-product-id'))
          #p itemsArray.size()
        end
      end

      itemsArray.uniq.each do |a|
        @driver.navigate.to(a)
        #p a
        begin
          sleep 2
          @wait.until {@driver.find_element(:css, 'li.calories .number').displayed?}
          nutritionalList = @driver.find_elements(:css, 'li.calories .number')
          #p nutritionalList[0].text
          if nutritionalList[0].text.empty?
            p "No Table #{a}"
          end
            #assert_not_empty(nutritionalList[0].text)
        rescue Selenium::WebDriver::Error::TimeOutError
          p "TimeOutError #{a}"
          next
        end


      end

    end




  end
end