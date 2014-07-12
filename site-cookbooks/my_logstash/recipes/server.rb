# Encoding: utf-8
#
# Author:: John E. Vincent
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, John E. Vincent
# Copyright 2012, Bryan W. Berry
# License: Apache 2.0
# Cookbook Name:: logstash
# Recipe:: server
#
#

# install logstash 'server'

name = 'server'

Chef::Application.fatal!("attribute hash node['logstash']['instance']['#{name}'] must exist.") if node['logstash']['instance'][name].nil?

# these should all default correctly.  listing out for example.
logstash_instance name do
  action            :create
end

# services are hard! Let's go LWRP'ing.   FIREBALL! FIREBALL! FIREBALL!
logstash_service name do
  action      [:enable]
end

file "#{node['logstash']['instance']['default']['basedir']}/#{name}/etc/#{name}.crt" do
  owner node['logstash']['instance']['default']['user']
  group node['logstash']['instance']['default']['group']
  content data_bag_item('logstash', name)['ssl_certificate']
  action :create
end

file "#{node['logstash']['instance']['default']['basedir']}/#{name}/etc/#{name}.key" do
  owner node['logstash']['instance']['default']['user']
  group node['logstash']['instance']['default']['group']
  content data_bag_item('logstash', name)['ssl_key']
  action :create
end

my_templates  = node['logstash']['instance'][name]['config_templates']

if my_templates.empty?
  my_templates = {
    'input_syslog' => 'config/input_syslog.conf.erb',
    'output_stdout' => 'config/output_stdout.conf.erb',
    'output_elasticsearch' => 'config/output_elasticsearch.conf.erb'
  }
end

instance_name = 'default'
instance_name = name if node['logstash']['instance'].key?(name) and node['logstash']['instance'][name]['config_templates_variables']
node.default['logstash']['instance'][instance_name]['config_templates_variables']['ssl_certificate_path'] = "#{node['logstash']['instance']['default']['basedir']}/#{name}/etc/#{name}.crt"
node.default['logstash']['instance'][instance_name]['config_templates_variables']['ssl_key_path'] = "#{node['logstash']['instance']['default']['basedir']}/#{name}/etc/#{name}.key"

logstash_config name do
  templates my_templates
  action [:create]
end
# ^ see `.kitchen.yml` for example attributes to configure templates.

logstash_plugins 'contrib' do
  instance name
  action [:create]
end

logstash_pattern name do
  action [:create]
end

logstash_service name do
  action      [:start]
end

logstash_curator 'server' do
  action [:create]
end
