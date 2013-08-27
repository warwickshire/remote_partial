required_items = [:exceptions, :time_calc, :yaml_store, :partial, :resource_manager, :builder]
required_items.each{|item| require_relative "remote_partial/#{item}"}
require_relative('remote_partial/railtie') if defined? Rails

module RemotePartial

  def self.define(args = {})
    Builder.build(args)
  end

  def self.partial_location
    if defined?(Rails)
      File.expand_path('app/views/remote_partials', Rails.root)
    else
      File.expand_path('remote_partials', root)
    end
  end

  def self.root
    @root || default_root
  end

  def self.root=(path)
    @root = path
  end

  def self.default_root
    if defined? Rails
      Rails.root
    else
      raise("You must define a root via: RemotePartial.root = 'some/path' ")
    end
  end

  def self.logger
    if defined? Rails
      Rails.logger
    else
      require 'logger'
      @logger ||= ruby_logger
    end
  end

  def self.ruby_logger
    require 'logger'
    Logger.new(logger_file)
  end

  def self.logger_file
    @logger_file || STDOUT
  end

  def self.logger_file=(path)
    @logger_file = File.expand_path(path, root)
  end

end
