#
# Cookbook:: node
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'node::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it "should install nginx" do
      expect(chef_run).to install_package 'nginx'
    end
#    it "should install nodejs" do
#      expect(chef_run).to install_package 'nodejs'
#    end

    it 'default apt update' do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it "should enable nginx service" do
      expect(chef_run).to enable_service "nginx"
    end

    it "should start nginx service" do
      expect(chef_run).to start_service "nginx"
    end

    it 'should create proxy template' do
      expect(chef_run).to create_template("/etc/nginx/sites-available/proxy.conf").with_variables(proxy_port: 3000)
    end

    it "should create a symlink of proxy.conf" do
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/proxy.conf').with_link_type(:symbolic)
    end

    it 'should delete the pre-existing symlink' do
      expect(chef_run).to delete_link('/etc/nginx/sites-enabled/default')
    end

    it 'should install nodejs from a recipe' do
      expect(chef_run).to include_recipe("nodejs")
    end

    it 'shoud install pm2' do
      expect(chef_run).to install_nodejs_npm('pm2')
    end

  end
end
