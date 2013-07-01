require 'test_helper'

class DemosControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success

  end

  def test_show_fixed
    get :show, id: 'fixed'
    assert_response :success
    assert_match content_of('fixed'), response.body
  end

  def content_of(remote_partial_name)
    File.read(Rails.root + "app/views/remote_partials/_#{remote_partial_name}.html.erb")
  end

end
