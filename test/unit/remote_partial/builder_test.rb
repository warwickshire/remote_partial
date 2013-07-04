require 'test_helper'

module RemotePartial
  class BuilderTest < ActiveSupport::TestCase

    def setup
      @partial = Partial.find(1)
      @name = 'foo'
      @url = @partial.url
      enable_mock(@url)
      new_builder
    end

    def teardown
      disable_mock
    end

    def test_create_or_update_partial
      assert_difference 'RemotePartial::Partial.count' do
        @builder.create_or_update_partial
      end
      assert_equal @name, Partial.last.name
    end

    def test_create_or_update_partial_updates_if_partial_exists
      test_create_or_update_partial
      @url = 'other'
      new_builder
      assert_no_difference 'RemotePartial::Partial.count' do
        @builder.create_or_update_partial
      end
      assert_equal @url, Partial.last.url
    end

    def test_build
      assert_expected_file_created do
        assert_difference 'RemotePartial::Partial.count' do
          Builder.build(
            url: @url,
            name: @name
          )
        end
        assert_equal(@name, Partial.last.name)
      end
    end
    
    def test_build_with_existing_stale_partial
      assert(@partial.stale?, "Partial needs to be stale at start of test")
      assert_output_file_updated do
        assert_no_difference 'RemotePartial::Partial.count' do
          Builder.build(
            url: @partial.url,
            name: @partial.name
          )
        end
      end
    end
    
    def test_build_with_existing_partial
      @partial.update_stale_at
      assert_output_file_not_updated do
        assert_no_difference 'RemotePartial::Partial.count' do
          Builder.build(
            url: @partial.url,
            name: @partial.name
          )
        end
      end
    end

    def assert_expected_file_created(&test)
      remove_file expected_output_file_name
      test.call
      assert_file_exists expected_output_file_name
      remove_file expected_output_file_name
    end

    def assert_expected_file_not_created(&test)
      remove_file @partial.output_file_name
      test.call
      assert_file_does_not_exist @partial.output_file_name
    end

    def new_builder
      @builder = Builder.new(
          name: @name,
          url: @url
      )
    end

    def expected_output_file_name
      @expected_output_file_name ||= @partial.output_file_name.gsub(@partial.name, @name)
    end
  end
end
