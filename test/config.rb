require 'test/unit'
require 'test/unit/rr'
require 'power_assert'
require 'yao'

require 'support/auth_stub'
require 'support/authv3_stub'
require 'support/restfully_accesible_stub'
require 'support/test_yao_resource'

require 'webmock/test_unit'

WebMock.disable_net_connect!
#WebMock.allow_net_connect!
