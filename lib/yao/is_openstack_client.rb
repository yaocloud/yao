unless defined? OpenStack
  module OpenStack
  end

  Yao = OpenStack

  # XXX: Some case, 'yao/version' is pre-required and
  # will delete Yao::VERSION const by reassign in L5
  unless require('yao/version')
    load 'yao/version.rb'
  end
end

require 'yao'
