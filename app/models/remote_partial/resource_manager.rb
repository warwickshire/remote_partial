require 'nokogiri'
require 'net/http'

module RemotePartial
  class ResourceManager
    attr_reader :content, :url, :criteria

    def self.get_page(url)
      Nokogiri::HTML(get_raw(url))
    end

    def self.get_raw(url)
      Net::HTTP.get(URI(url))
    end

    def initialize(url, criteria = nil)
      @url = url
      @content = self.class.get_page(url)
      @criteria = criteria
    end

    def html
      return content.to_s unless criteria
      content.search(criteria).to_s
    end

    def output_to(path)
      @path = path
      ensure_output_folder_exists
      File.write(path, html)
    end

    private
    def output_folder
      File.dirname(@path)
    end

    def ensure_output_folder_exists
      FileUtils.mkdir_p(output_folder) unless output_folder_exists?
    end

    def output_folder_exists?
      Dir.exists?(output_folder)
    end

  end
end
