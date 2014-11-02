def whyrun_supported?
  true
end

action :create do
    converge_by("Create #{@new_resource}") do
        create_p4_proxy
    end
end

def load_current_resource
    @current_resource = Chef::Resource::KitchenP4P4proxy.new(@new_resource.name)
    @current_resource.name(@new_resource.name)
    @current_resource.ipv4_address(@new_resource.ipv4_address)
    @current_resource.port_num(@new_resource.port_num)
end

def create_p4_proxy
    puts "hello"
    #file = ::File.new('/tmp/p4p','w')
    #print file "create p4p xxx"
    #file.close
end
