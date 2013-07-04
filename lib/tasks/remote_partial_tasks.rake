namespace :remote_partial do

  desc "Updates remote partials"
  task :update => :environment do
    # Don't need to do anything more than reload the environment, as remote
    # partials are reloaded on application start.
    Rails.logger.info "Updated remote partials at #{Time.now.to_s(:db)}"
  end
  
end
