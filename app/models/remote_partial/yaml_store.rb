require 'yaml'
require 'hashie'

module RemotePartial
  class YamlStore < Hashie::Mash
    
    def self.write(hash)
      ensure_directory_exists
      output = string_keys(hash).to_yaml
      File.open(file, 'w+') { |file| file.write(output) }
    end

    def self.read
      File.exists?(file) ? YAML.load_file(file) : {}
    end

    def self.create(hash)
      new(string_keys(hash)).save
    end

    def self.find(name)
      name = name.to_s
      item = read[name]
      new(item.merge(name: name)) if item
    end

    def self.all
      read.keys.collect{|name| find(name)}
    end

    def self.count
      read.keys.length
    end

    def self.file
      @file ||= File.expand_path("#{name.tableize}.yml", root)
    end

    def self.root
      location = Rails.env == 'test' ? 'test/db' : 'db'
      File.expand_path(location, Rails.root)
    end

    def self.dir
      File.dirname file
    end

    def self.merge!(hash)
      write(read.merge(string_keys(hash)))
    end

    def self.string_keys(hash)
      hash.inject({}){|h,(key,value)| h[key.to_s] = value; h}
    end

    def save
      raise "You must define a name before saving" unless name
      update_time_stamps
      self.class.merge!({name.to_s => data_stored_in_object})
      self
    end

    def time_stamps
      {
        'created_at' => created_at,
        'updated_at' => updated_at
      }
    end

    private
    def self.ensure_directory_exists
      dir.split(/\//).inject do |path, folder|
        current_path = [path, folder].join('/')
        Dir.mkdir(current_path) unless Dir.exists?(current_path)
        current_path
      end
    end

    def update_time_stamps
      self.created_at = Time.now unless created_at?
      self.updated_at = Time.now
    end

    def data_stored_in_object
      data = to_hash
      data.delete('name')
      data
    end

  end
end
