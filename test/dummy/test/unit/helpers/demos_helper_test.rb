require 'test_helper'
require 'remote_partial/host_app_helper'

class DemosHelperTest < ActionView::TestCase
  include RemotePartial::HostAppHelper

  def test_render_remote_partial_with_no_partial
    assert_raise ActionView::MissingTemplate do
      render_remote_partial 'non-existent-partial'
    end
  end

end
