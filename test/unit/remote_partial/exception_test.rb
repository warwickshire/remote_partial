require 'test_helper'

module RemotePartial
  class ExceptionTest < MiniTest::Unit::TestCase
    def test_remote_partial_retrival_error
      inner_message = 'Whoops'
      catch_exception { raise RemotePartialRetrivalError.new(inner_message, Array)}
      assert_match("Unable to retrieve remote partial", @exception.message)
      assert_match(inner_message, @exception.message)
      assert_match('Array', @exception.message)
    end

    def catch_exception(&process)
      begin
        process.call
      rescue => e
        @exception = e
      end
    end
  end
end
