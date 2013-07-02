require 'strong_parameters'
module RemotePartial
  class Partial < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection

    validates :name, :url, presence: true

  end
end
