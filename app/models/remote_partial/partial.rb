require 'strong_parameters'
module RemotePartial
  class Partial < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection

    before_save :reset_stale_at

    validates :name, :url, presence: true

    def output_file_name
      [partial_folder, file_name].join("/")
    end

    def update_file
      resource_manager.output_to output_file_name
    end

    def criteria
      super if super.present? # ensure criteria doesn't return empty string
    end

    def resource_manager
      ResourceManager.new(url, criteria)
    end

    def perform
      update_file
    end
    
    def repeat_period
      super.present? ? super : 60
    end

    def reset_stale_at
      self.stale_at = Time.now + repeat_period
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
