#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
package 'nginx'
#package 'nodejs'
apt_update 'update_sources' do
  action :update
end
service 'nginx' do
  action [:enable, :start]
end

include_recipe 'apt'
include_recipe 'nodejs'


template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end

link "/etc/nginx/sites-enabled/proxy.conf" do
  to '/etc/nginx/sites-available/proxy.conf'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end
