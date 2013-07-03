require "remote_partial/engine"
require 'delayed_job_active_record'
require 'webmock'
WebMock.disable! unless ENV["RAILS_ENV"] == "test"

module RemotePartial

  def self.define(args = {})
    Builder.build(args)
  end

  def self.partial_location
    @partial_location || File.expand_path('app/views/remote_partials', Rails.root)
  end

  def self.partial_location=(path)
    @partial_location = path
  end

end
