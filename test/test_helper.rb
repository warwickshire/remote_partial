# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'webmock/test_unit'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

class ActiveSupport::TestCase
  fixtures :all

  def enable_mock(url, body = '<body><h1>Something</h1><p>Else</p></body>')
    WebMock.enable!
    stub_request(:get, url).
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => body, :headers => {})
  end

  def disable_mock
    WebMock.disable!
  end

  def assert_equal_ignoring_cr(expected, testing, comment = nil)
    cr = "\n"
    assert_equal(expected, testing.gsub(cr, ""), comment)
  end

  def remove_file(file_name)
    File.delete(file_name) if File.exists?(file_name)
  end

  def assert_file_exists(file_name)
    assert(File.exists?(file_name), "File should exist: #{file_name}")
  end

  def assert_file_does_not_exist(file_name)
    assert(!File.exists?(file_name), "File should not exist: #{file_name}")
  end


  def assert_output_file_updated(content = nil, &test)
    remove_output_file
    test.call
    assert_file_exists @partial.output_file_name
    assert_equal_ignoring_cr(content, File.read(@partial.output_file_name)) if content
    remove_output_file
  end

  def assert_output_file_not_updated(&test)
    remove_output_file
    test.call
    assert_file_does_not_exist @partial.output_file_name
  end

  def remove_output_file
    remove_file @partial.output_file_name
  end

end