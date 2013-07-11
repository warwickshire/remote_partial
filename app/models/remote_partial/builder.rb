
module RemotePartial
  class Builder
    attr_reader :args, :partial, :changed

    def self.build(args)
      builder = new(args)
      builder.run
    end

    def initialize(args)
      @args = Partial.string_keys(args)
    end
    
    def run
      create_or_update_partial
#      puts "stale_at: #{@partial.stale_at}, and stale? == #{@partial.stale?}"
      partial.update_stale_file
    rescue RemotePartialRetrivalError => error
      Rails.logger.warn error.message
    end

    def create_or_update_partial
      @partial = Partial.find(args['name']) || Partial.new(name: args['name'])
      track_change(args, 'url')
      track_change(args, 'criteria')
      track_change(args, 'repeat_period', @partial.default_repeat_period)

      if changed
        @partial.save
      end
    end

    private
    def track_change(args, attribute, default = nil)
      unless @partial.send(attribute) == args[attribute] or (default and @partial.send(attribute) == default)
        @partial.send("#{attribute}=".to_sym, args.fetch(attribute, default))
        @changed = true
      end
    end

  end
end
