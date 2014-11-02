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

# check p4 port in use or not
# check p4 proxy doc if already has this port or proxy test if it is up or not
# if not be there add one line there and add to crontab
def check_p4_port(port_num)

end

def create_p4_proxy
    puts "hello"
    #file = ::File.new('/tmp/p4p','w')
    #print file "create p4p xxx"
    #file.close
end
