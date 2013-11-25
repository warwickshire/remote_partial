
module RemotePartial
  class Partial < YamlStore

    attr_accessor :stale_at, :repeat_period

    def output_file_name
      [partial_folder, file_name].join("/")
    end

    def update_file
      resource_manager.output_to(output_file_name)
      update_stale_at
    end

    def update_stale_file
      update_file if stale?
    end

    def criteria
      super if present?(super)
    end

    def resource_manager
      ResourceManager.new(url, criteria, &output_modifier_to_lambda)
    end
    
    def repeat_period
      @repeat_period ||= determine_repeat_period.to_f
    end

    def default_repeat_period
      TimeCalc.minutes(1)
    end

    def update_stale_at
      reset_stale_at if stale?
    end

    def reset_stale_at
      self.stale_at = (Time.now + repeat_period)
      save
    end

    def stale_at
      @stale_at || self[:stale_at] || self['stale_at']
    end

    def stale?
      stale_at_blank? or stale_at < Time.now
    end

    def to_hash
      super.merge('stale_at' => stale_at)
    end

    private
    def partial_folder
      RemotePartial.partial_location
    end

    def file_name
      "_#{name}.html.erb"
    end

    def output_modifier_to_lambda
      output_modifier? ? instance_eval("lambda #{output_modifier}") : nil
    end

    def stale_at_blank?
      return true unless stale_at
      !stale_at.kind_of? Time
    end

    def present?(item)
      item and item.to_s !~ empty_string_pattern
    end

    def empty_string_pattern
      /\A\s*\Z/
    end

    def determine_repeat_period
      self[:repeat_period] || self['repeat_period'] || default_repeat_period
    end
  end
end
