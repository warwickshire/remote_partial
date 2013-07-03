require 'test_helper'

class RemotePartialTest < ActiveSupport::TestCase
  def test_define
    assert_difference 'RemotePartial::Partial.count' do
      RemotePartial.define(
        url: 'http://www.warwickshire.gov.uk',
        name: 'wcc'
      )
    end
    assert_equal('wcc', RemotePartial::Partial.last.name)
  end

  def test_partial_location
    expected = File.expand_path('../../dummy/app/views/remote_partials', __FILE__)
    assert_equal expected, RemotePartial.partial_location
  end

  def test_set_partial_location
    location = '/tmp'
    RemotePartial.partial_location = location
    assert_equal location, RemotePartial.partial_location
    RemotePartial.partial_location = nil
    test_partial_location
  end
end
