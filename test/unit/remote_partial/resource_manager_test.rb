require 'test_helper'
require 'nokogiri'
require 'net/http'

module RemotePartial
  class ResourceManagerTest < MiniTest::Unit::TestCase

    def setup
      @url = "http://www.worcestershire.gov.uk"
      @body = "<body><p>One</p><h1>Foo</h1><p>Bar</p></body>"
      enable_mock(@url, @body)
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

    def test_get_raw_with_http
      url = "https://www.worcestershire.gov.uk"
      enable_mock(url, @body)
      enable_mock("http://www.worcestershire.gov.uk:443")
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      raw = response.body
      assert_equal raw, ResourceManager.get_raw(url)
    end

    def test_html
      resource_manager = ResourceManager.new(@url)
      assert_equal raw_content, resource_manager.html
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

    def test_html_with_proc_mod
      expected = '<p>One</p><p>Two</p>'
      resource_manager = ResourceManager.new(@url, 'p') {|text| text.gsub(/Bar/, 'Two')}
      assert_equal_ignoring_cr expected, resource_manager.html
    end

    def test_output_to
      test_html_with_limit
      @resource_manager.output_to(@path)
      assert_equal_ignoring_cr(@body, File.read(@path))
    end

    def test_connection_failure
      enable_mock_connection_failure @url
      assert_raises RemotePartialRetrivalError do
        ResourceManager.new(@url, 'body').html
      end
    end

    def test_connection_failure_due_to_invalid_url
      enable_mock_connection_error @url
      assert_raises RemotePartialRetrivalError do
        ResourceManager.new(@url, 'body').html
      end
    end

    def test_http_proxy_environment_variable_not_set
      ENV.delete('http_proxy')
      uri = URI.parse @url
      settings = ResourceManager.connection_settings(uri)
      assert_equal([uri.host, uri.port], settings)
    end

    def test_http_proxy_environment_variable_without_credentials
      ENV['http_proxy'] = "http://10.10.10.254:8080"
      uri = URI.parse @url
      settings = ResourceManager.connection_settings(uri)
      assert_equal([uri.host, uri.port, '10.10.10.254', 8080, nil, nil], settings)
    end

    def test_http_proxy_environment_variable_with_credentials
      ENV['http_proxy'] = "http://fred:daphne@10.10.10.254:8080"
      uri = URI.parse @url
      settings = ResourceManager.connection_settings(uri)
      assert_equal([uri.host, uri.port, '10.10.10.254', 8080, 'fred', 'daphne'], settings)
    end

    def raw_content
      Net::HTTP.get(URI(@url))
    end

    def content
      Nokogiri::HTML(raw_content)
    end

  end
end
