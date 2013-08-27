require 'test_helper'

module RemotePartial
  class BuilderTest < MiniTest::Unit::TestCase

    def setup
      @partial = Partial.create(
        name: 'simple',
        url: 'http://www.warwickshire.gov.uk',
        criteria: 'p:first-child',
        repeat_period:  TimeCalc.minutes(10)
      )
      @name = 'foo'
      @url = @partial.url
      enable_mock @url
      new_builder
    end

    def teardown
      File.delete(Partial.file) if File.exists?(Partial.file)
    end

    def test_create_or_update_partial
      assert_difference 'RemotePartial::Partial.count' do
        @builder.create_or_update_partial
      end
      assert Partial.find @name
    end

    def test_create_or_update_partial_updates_if_partial_exists
      test_create_or_update_partial
      @url = 'other'
      new_builder
      assert_no_difference 'RemotePartial::Partial.count' do
        @builder.create_or_update_partial
      end
      assert_equal @url, Partial.find(@name).url
    end

    def test_build
      assert_expected_file_created do
        assert_difference 'RemotePartial::Partial.count' do
          Builder.build(
            url: @url,
            name: @name
          )
        end
        assert_equal(@name, Partial.find(@name).name)
      end
    end
    
    def test_build_with_existing_stale_partial
      assert(@partial.stale?, "Partial should be stale at start of test")
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
      partial = Partial.find(@partial.name)
      assert_output_file_not_updated do
        assert_no_difference 'RemotePartial::Partial.count' do
          Builder.build(
            url: @partial.url,
            name: @partial.name
          )
        end
      end
    end

    def test_build_with_http_error
      enable_mock_connection_failure @url
      assert_log_entry_added('HTTPBadRequest') do
        assert_output_file_not_updated do
          assert_no_difference 'RemotePartial::Partial.count' do
            Builder.build(
              url: @partial.url,
              name: @partial.name
            )
          end
        end
      end
    end

    def test_stale_at_not_modified_if_unable_to_retrieve
      expected = @partial.stale_at
      test_build_with_http_error
      assert_equal(expected, Partial.find(@partial.name).stale_at)
    end

    def test_builder_with_output_modifier
      output_modifier = '{|t| "Hello"}'
      name = 'partial_with_mod'
      assert_difference 'RemotePartial::Partial.count' do
        Builder.build(
          url: @partial.url,
          name: name,
          output_modifier: output_modifier
        )
      end
      partial = Partial.find(name)
      assert_equal(output_modifier, partial.output_modifier)
      remove_file(partial.output_file_name)
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
      @expected_output_file_name ||= @partial.output_file_name.gsub(@partial.name.to_s, @name)
    end
  end
end
