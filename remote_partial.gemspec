$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "remote_partial/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "remote_partial"
  s.version     = RemotePartial::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RemotePartial."
  s.description = "TODO: Description of RemotePartial."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "nokogiri"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "webmock"
end
