require 'test_helper'

class RemotePartialTest < MiniTest::Unit::TestCase

  def setup
    enable_mock url, 'Some content'
  end

  def teardown
    remove_file(RemotePartial::Partial.file)
  end

  def test_define_with_string_keys
    assert_difference 'RemotePartial::Partial.count' do
      RemotePartial.define(
        'url' => url,
        'name' => name
      )
    end
    assert_partial_content_correct
  end

  def test_define   
    assert_difference 'RemotePartial::Partial.count' do
      RemotePartial.define(
        url: url,
        name: name
      )
    end
    assert_partial_content_correct
  end

  def url
    'http://www.warwickshire.gov.uk'
  end

  def name
    'wcc'
  end

  def assert_partial_content_correct
    partial = RemotePartial::Partial.find(name)
    assert_equal(url, partial.url)
    remove_file(partial.output_file_name)
  end

end
