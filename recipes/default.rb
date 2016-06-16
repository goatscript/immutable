#
# Cookbook Name:: immutable
# Recipe:: chattr
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file '/opt/chef-vault-2.9.0.gem' do
  source 'chef-vault-2.9.0.gem'
  mode '0755'
  action :nothing
end.run_action(:create)

#Chef::Resource::File.resource_name(:cookbook_file=>'chef-vault-2.9.0.gem').run_action(:create)

chef_gem 'chef-vault' do
  compile_time true
  source '/opt/chef-vault-2.9.0.gem'
  action :install
end

require 'chef-vault'

unique = ChefVault::Item.load('machine_lock',"#{node[:immutable][:vault_info]}")

pathway = node[:immutable][:immutable_file]
#unique = data_bag_item('machine_lock','ticket')

template pathway do
  mode '0444'
  source "immutable.erb"
  variables :project => unique['data']
  notifies :run, "bash[immutable]", :immediately
end

bash 'immutable' do
  user 'root'
  code <<-EOH
    chattr +i "#{node[:immutable][:immutable_file]}"
    EOH
  action :nothing
end
