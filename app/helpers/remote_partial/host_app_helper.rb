# Helper methods added here, should be available to the host app

module RemotePartial
  module HostAppHelper

    def render_remote_partial(name)
      partial = RemotePartial::Partial.find_by_name(name)
      if partial
        render template: partial.output_file_name
      else
        render partial: "remote_partials/#{name}"
      end
    end
    
  end
end
