require "remote_partial/engine"

module RemotePartial

  def self.define(args = {})
    Builder.build(args)
  end

end
