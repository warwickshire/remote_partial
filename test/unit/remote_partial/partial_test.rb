require 'test_helper'

module RemotePartial
  class PartialTest < ActiveSupport::TestCase

    def setup
      create_partial_for('http://www.warwickshire.gov.uk')
    end

    def teardown
      File.delete(Partial.file) if File.exists?(Partial.file)
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

    def test_update_file_with_https_url
      enable_mock("http://www.warwickshire.gov.uk:443/")
      create_partial_for('https://www.warwickshire.gov.uk')
      test_update_file
    end

    def test_update_file_with_output_modifier
      @partial.output_modifier = '{|text| text.gsub(/One/, "Two")}'
      expected = '<p>Two</p>'
      assert_output_file_updated(expected) do
        @partial.update_file
      end
    end

    def test_update_stale_at
      @partial.update_stale_at
      @expected = @partial.updated_at + @partial.repeat_period
      assert_equal @expected.to_s(:db), @partial.stale_at.to_s(:db)
    end

    def test_stale_at_gets_into_hash
      test_update_stale_at
      hash = @partial.to_hash
      assert_equal @expected.to_s(:db), hash['stale_at'].to_s(:db)
    end

    def test_stale_at_gets_into_file
      test_update_stale_at
      partial = Partial.find(@partial.name)
      assert_equal partial.stale_at, @partial.stale_at
    end

    def test_stale_at_not_updated_unless_stale
      test_update_stale_at
      before = @partial.stale_at
      @partial.update_stale_at
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

    def create_partial_for(url)
      @first_p = '<p>One</p>'
      @body = "<body><h1>Foo</h1><div>#{@first_p}<p>Bar</p></div></body>"
      enable_mock(url, @body)

      @partial = Partial.create(
        name: :simple,
        url: url,
        criteria: 'p:first-child',
        repeat_period:  10.minutes
      )
    end

  end
end
