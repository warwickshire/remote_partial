module RemotePartial
  class Railtie < Rails::Railtie
    railtie_name :remote_partial

    rake_tasks do
      load "tasks/remote_partial_tasks.rake"
    end
  end
end
