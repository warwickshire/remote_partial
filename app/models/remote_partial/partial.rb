
module RemotePartial
  class Partial < YamlStore

    attr_accessor :stale_at, :repeat_period

    def output_file_name
      [partial_folder, file_name].join("/")
    end

    def update_file
      resource_manager.output_to output_file_name
      update_stale_at
    end

    def update_stale_file
      update_file if stale?
    end

    def criteria
      super if super.present? # ensure criteria doesn't return empty string
    end

    def resource_manager
      ResourceManager.new(url, criteria)
    end
    
    def repeat_period
      @repeat_period ||= default_repeat_period
    end

    def default_repeat_period
      60
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
      stale_at.blank? or stale_at < Time.now
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

  end
end
