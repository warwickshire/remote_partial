module RemotePartial
  class Engine < ::Rails::Engine
    isolate_namespace RemotePartial

    initializer 'remote_partial.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper RemotePartial::HostAppHelper
      end
    end
  end
end
