require 'test_helper'
require 'nokogiri'
require 'net/http'

module RemotePartial
  class ResourceManagerTest < ActiveSupport::TestCase

    def setup
      @url = "http://www.worcestershire.gov.uk"
      @body = "<body><p>One</p><h1>Foo</h1><p>Bar</p></body>"
      stub_request(:get, @url).
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => @body, :headers => {})

      @path = 'temp/file.text'
      File.delete(@path) if File.exists?(@path)
    end

    def test_stub
      assert_equal_ignoring_cr(@body, content.search('body').to_s)
    end

    def test_get_page
      assert_equal(content.to_s, ResourceManager.get_page(@url).to_s)
    end

    def test_get_raw
      raw = Net::HTTP.get(URI(@url))
      assert_equal raw, ResourceManager.get_raw(@url)
    end

    def test_html
      resource_manager = ResourceManager.new(@url)
      assert_equal content.to_s, resource_manager.html
    end

    def test_html_with_limit
      @resource_manager = ResourceManager.new(@url, 'body')
      assert_equal_ignoring_cr @body, @resource_manager.html
    end

    def test_html_with_limit_that_returns_multiple_matches
      expected = '<p>One</p><p>Bar</p>'
      resource_manager = ResourceManager.new(@url, 'p')
      assert_equal_ignoring_cr expected, resource_manager.html
    end

    def test_output_to
      test_html_with_limit
      @resource_manager.output_to(@path)
      assert_equal_ignoring_cr(@body, File.read(@path))
    end

    def content
      Nokogiri::HTML(Net::HTTP.get(URI(@url)))
    end



  end
end
