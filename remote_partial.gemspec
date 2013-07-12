$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "remote_partial/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "remote_partial"
  s.version     = RemotePartial::VERSION
  s.authors     = ["Rob Nichols"]
  s.email       = ["rob@undervale.co.uk"]
  s.homepage    = "https://github.com/warwickshire/remote_partial"
  s.summary     = "RemotePartial adds the facility to grab content from remote sites and add them as partials to the host app."
  s.description = <<EOF
RemotePartial comprises:
  a system to grab content from a remote page and copy that content into partials;
  a process to allow content to be regularly updated;
  a helper method to ease inclusion of the partial with a view"
EOF

  s.license = 'MIT-LICENSE'
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "nokogiri"
  s.add_dependency 'hashie'

end
