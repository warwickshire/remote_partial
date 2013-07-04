require 'strong_parameters'
module RemotePartial
  class Partial < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection

    validates :name, :url, presence: true

    def output_file_name
      [partial_folder, file_name].join("/")
    end

    def update_file
      resource_manager.output_to output_file_name
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
      super.present? ? super : 60
    end

    def update_stale_at
      reset_stale_at if stale?
    end

    def reset_stale_at
      update_attribute(:stale_at, (Time.now + repeat_period))
    end

    def stale?
      stale_at.blank? or stale_at < Time.now
    end

    private
    def partial_folder
      RemotePartial.partial_location.gsub(tailing_slash_pattern, "")
    end

    def file_name
      "_#{name}.html.erb"
    end

    def tailing_slash_pattern
      /\/$/
    end

  end
end
