unless defined? OpenStack
  module OpenStack
  end

  Oslo = OpenStack

  # XXX: Some case, 'oslo/version' is pre-required and
  # will delete Oslo::VERSION const by reassign in L5
  unless require('oslo/version')
    load 'oslo/version.rb'
  end
end

require 'oslo'
