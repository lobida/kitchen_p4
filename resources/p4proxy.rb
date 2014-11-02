require 'resolv'

actions :create
default_action :create

attribute :proxy_name, :name_attribute => true, :kind_of => String, :required => true
attribute :ipv4_address, :kind_of => String, :required => true, :regex => Resolv::IPv4::Regex
attribute :port_num, :kind_of => Integer, :required => true
attribute :catch_path, :kind_of => String, :required => true
attribute :p4p_version, :kind_of => String, :default => '2014.1'
