# Helper methods added here, should be available to the host app

module RemotePartial
  module HostAppHelper

    def render_remote_partial(name)
      render partial: "remote_partials/#{name}"
    end
    
  end
end
