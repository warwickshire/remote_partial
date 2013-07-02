require 'test_helper'

module RemotePartial
  class BuilderTest < ActiveSupport::TestCase

    def setup
      @name = 'foo'
      @url = 'bar'
      @builder = Builder.new(
          name: @name,
          url: @url
      )
    end

    def test_create_or_update_partial
      assert_difference 'RemotePartial::Partial.count' do
        @builder.create_or_update_partial
      end
      assert_equal @name, Partial.last.name
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
  end
end
