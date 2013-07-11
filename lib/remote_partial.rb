require "remote_partial/engine"
require_relative '../app/models/remote_partial/exceptions'

module RemotePartial

  def self.define(args = {})
    Builder.build(args)
  end

  def self.partial_location
    File.expand_path('app/views/remote_partials', Rails.root)
  end

end
