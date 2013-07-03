require 'test_helper'

module RemotePartial
  class BuilderTest < ActiveSupport::TestCase

    def setup
      @name = 'foo'
      @url = Partial.find(1).url
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
       assert_difference 'RemotePartial::Partial.count' do
         Builder.build(
           url: @url,
           name: @name
         )
       end
       assert_equal(@name, Partial.last.name)
    end

    def new_builder
      @builder = Builder.new(
          name: @name,
          url: @url
      )
    end
  end
end
