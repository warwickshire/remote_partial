require 'test_helper'

module RemotePartial
  class PartialTest < ActiveSupport::TestCase

    def setup      
      @partial = Partial.find(1)
      @first_p = '<p>One</p>'
      @body = "<body><h1>Foo</h1><div>#{@first_p}<p>Bar</p></div></body>"
      enable_mock(@partial.url, @body)
    end

    def teardown
      disable_mock
    end

    def test_output_file_name
      expected = "#{RemotePartial.partial_location}/_#{@partial.name}.html.erb"
      assert_equal expected, @partial.output_file_name
    end

    def test_update_file
      assert_output_file_updated(@first_p) do
        @partial.update_file
      end

    end

    def test_update_stale_at
      @partial.update_stale_at
      expected = @partial.updated_at + @partial.repeat_period
      assert_equal expected.to_s(:db), @partial.stale_at.to_s(:db)
    end

    def test_stale_at_not_updated_unless_stale
      test_update_stale_at
      before = @partial.stale_at
      @partial.save
      assert_equal before, @partial.stale_at
    end

    def test_stale_at_reset_if_stale
      @partial.stale_at = 1.hour.ago
      test_update_stale_at
    end

    def test_update_stale_file
      assert_output_file_updated(@first_p) do
        @partial.update_stale_file
      end
    end

    def test_update_stale_file_when_not_stale
      test_update_stale_at
      assert_output_file_not_updated do
        @partial.update_stale_file
      end
    end

    def test_update_file_not_affected_by_stale_state
      test_update_stale_at
      test_update_file
    end

  end
end
