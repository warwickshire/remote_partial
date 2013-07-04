require 'nokogiri'
require 'net/http'

module RemotePartial
  class ResourceManager
    attr_reader :content, :url, :criteria

    def self.get_page(url)
      Nokogiri::HTML(get_raw(url))
    end

    def self.get_raw(url)
      response = Net::HTTP.get_response(URI(url))
      
      case response.code.to_i
      when ok_response_codes
        return response.body
      when redirect_response_codes
        get_raw(URI.parse(response['location']))
      else
        raise response.inspect
      end
    rescue => exception # Do main exception raising outside of case statement so that SocketErrors are also handled
      raise RemotePartialRetrivalError.new(url, exception)
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

    def self.ok_response_codes
      200..299
    end

    def self.redirect_response_codes
      300..399
    end

  end
end
