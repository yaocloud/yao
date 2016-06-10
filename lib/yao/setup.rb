require 'yao'

Yao.config do
  auth_url    ENV['OS_AUTH_URL']
  tenant_name ENV['OS_TENANT_NAME']
  username    ENV['OS_USERNAME']
  password    ENV['OS_PASSWORD']
end
