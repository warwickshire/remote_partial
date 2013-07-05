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

end
