#
# Cookbook Name:: immutable
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file '/opt/chef-vault-2.9.0.gem' do
  source 'chef-vault-2.9.0.gem'
  mode '0755'
  action :nothing
end.run_action(:create)


chef_gem 'chef-vault' do
  compile_time true
  source '/opt/chef-vault-2.9.0.gem'
  action :install
end

require 'chef-vault'

unique = ChefVault::Item.load('machine_lock',"#{node[:immutable][:vault_info]}")

pathway = node[:immutable][:immutable_file]

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
