require 'nokogiri'
require 'net/http'

module RemotePartial
  class ResourceManager
    attr_reader :url, :criteria, :output_modifier

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

    def initialize(url, criteria = nil, &output_modifier)
      @url = url
      @criteria = criteria
      @output_modifier = output_modifier
    end

    def output_to(path)
      @path = path
      ensure_output_folder_exists
      File.write(path, html)
    end

    def html
      text = criteria ? get_part_of_page : get_whole_page
      output_modifier ? output_modifier.call(text) : text
    end

    private
    def get_whole_page
      self.class.get_raw(@url).force_encoding('UTF-8')
    end

    def get_part_of_page
      self.class.get_page(@url).search(criteria).to_s
    end

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
