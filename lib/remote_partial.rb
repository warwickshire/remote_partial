require "remote_partial/engine"
require_relative '../app/models/remote_partial/exceptions'

begin
  require 'webmock'
  WebMock.disable! if defined?(WebMock)
rescue LoadError
  # Ignore - WebMock not available
end
module RemotePartial

  def self.define(args = {})
    Builder.build(args)
  end

  def self.partial_location
    path = @partial_location || File.expand_path('app/views/remote_partials', Rails.root)
    path.gsub(tailing_slash_pattern, "")
  end

  def self.partial_location=(path)
    @partial_location = path
  end

  private
  def self.tailing_slash_pattern
    /\/$/
  end

end
