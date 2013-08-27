namespace :remote_partial do

  desc "Updates remote partials"
  task :update => :environment do
    RemotePartial::Partial.all.each{|partial| puts partial.name if partial.update_stale_file }
    RemotePartial.logger.info "Updated remote partials at #{Time.now.to_s(:db)}"
  end

  desc "Force update of all remote partials"
  task :force_update => :environment do
    RemotePartial::Partial.all.each{|partial| puts partial.name if partial.update_file }
    RemotePartial.logger.info "Forced update of remote partials at #{Time.now.to_s(:db)}"
  end
  
end
