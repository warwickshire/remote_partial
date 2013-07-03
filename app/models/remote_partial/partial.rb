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

    def criteria
      super if super.present? # ensure criteria doesn't return empty string
    end

    def resource_manager
      ResourceManager.new(url, criteria)
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
