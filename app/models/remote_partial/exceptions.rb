module RemotePartial

  class RemotePartialRetrivalError < StandardError
    attr_reader :url, :source

    def initialize(url, source)
      @url = url
      @source = source
    end

    def message
      "Unable to retrieve remote partial at #{url}: #{error_message}"
    end

    def error_message
      if source.class == RuntimeError
        source.message
      else
        source.inspect
      end
    end
  end

end
