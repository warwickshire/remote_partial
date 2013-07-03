
module RemotePartial
  class Builder
    attr_reader :args, :partial

    def self.build(args)
      builder = new(args)
      builder.run
    end

    def initialize(args)
      @args = args
    end
    
    def run
      create_or_update_partial
      partial.perform
    end


    def create_or_update_partial
      @partial = Partial.find_or_initialize_by_name(args[:name])
      @partial.url = args[:url]
      @partial.criteria = args[:criteria]
      @partial.repeat_period = args.fetch(:repeat_period, 12.hour)
      @partial.save
    end
  end
end
