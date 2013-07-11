require 'test_helper'

class RemotePartialTest < ActiveSupport::TestCase

  def teardown
    File.delete(RemotePartial::Partial.file) if File.exists?(RemotePartial::Partial.file)
  end

  def test_define_with_string_keys
    url = 'http://www.warwickshire.gov.uk'
    name = 'wcc'
    assert_difference 'RemotePartial::Partial.count' do
      RemotePartial.define(
        'url' => url,
        'name' => name
      )
    end
    assert_equal(url, RemotePartial::Partial.find(name).url)
  end

  def test_define
    url = 'http://www.warwickshire.gov.uk'
    name = 'wcc'
    assert_difference 'RemotePartial::Partial.count' do
      RemotePartial.define(
        url: url,
        name: name
      )
    end
    assert_equal(url, RemotePartial::Partial.find(name).url)
  end

end
