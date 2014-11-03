require 'resolv'

actions :create
default_action :create

attribute :proxy_name, :name_attribute => true, :kind_of => String, :required => true
attribute :ipv4_address, :kind_of => String, :required => false, :regex => Resolv::IPv4::Regex
attribute :port_num, :kind_of => Integer, :required => true
attribute :cach_path, :kind_of => String, :required => true
attribute :p4p_version, :kind_of => String, :default => '2012.1/473528/p4p'
