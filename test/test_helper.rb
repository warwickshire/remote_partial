require 'pathname'
require 'minitest/unit'
require 'webmock'
require 'webmock/minitest'
require 'webmock/test_unit'
require_relative '../lib/remote_partial'

RemotePartial.root = File.expand_path('..', __FILE__)
RemotePartial.logger_file = 'log/test.log'

class MiniTest::Unit::TestCase

  def enable_mock(url, body = '<body><h1>Something</h1><p>Else</p></body>')
    stub_request(:get, url).
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => body, :headers => {})
  end

  def enable_mock_connection_failure(url, status = 400)
    stub_request(:get, url).
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => status, :body => 'Whoops!', :headers => {})
  end

  def enable_mock_connection_error(url)
    stub_request(:get, url).to_raise(SocketError.new("Some connection error"))
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

  def assert_difference(expression, difference = 1, message = nil, &block)
    expressions = Array(expression)

    exps = expressions.map { |e|
      e.respond_to?(:call) ? e : lambda { eval(e, block.binding) }
    }
    before = exps.map { |e| e.call }

    yield

    expressions.zip(exps).each_with_index do |(code, e), i|
      error  = "#{code.inspect} didn't change by #{difference}"
      error  = "#{message}.\n#{error}" if message
      assert_equal(before[i] + difference, e.call, error)
    end
  end

  def assert_no_difference(expression, message = nil, &block)
    assert_difference expression, 0, message, &block
  end

  def assert_log_entry_added(text, &block)
    RemotePartial.logger.info 'Preparing to test logging via assert_log_entry_added'
    before = File.size(RemotePartial.logger_file)
    block.call
    assert(before < File.size(RemotePartial.logger_file), "#{RemotePartial.logger_file} should have increased in size")
    last_entry = File.readlines(RemotePartial.logger_file).last
    assert_match text, last_entry, "Logger output should contain #{text}"

  end

  def remove_output_file
    remove_file @partial.output_file_name
  end

end
