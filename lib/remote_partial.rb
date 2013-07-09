require "remote_partial/engine"
require_relative '../app/models/remote_partial/exceptions'

module RemotePartial

  def self.define(args = {})
    if Partial.table_exists?
      Builder.build(args)
    else
      unless @remote_partial_table_missing_message_logged
        message = "RemotePartial.define will not run until the '#{Partial.table_name}' table exists. See RemotePartial README"
        puts message
        Rails.logger.warn message
        @remote_partial_table_missing_message_logged = true
      end
    end
  end

  def self.partial_location
    File.expand_path('app/views/remote_partials', Rails.root)
  end

end
