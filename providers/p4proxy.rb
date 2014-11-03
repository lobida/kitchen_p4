def whyrun_supported?
  true
end

action :create do
    converge_by("Create #{@new_resource}") do
        load_current_resource
        if port_used?(@current_resource.ipv4_address, @current_resource.port_num)
            puts "ports used"
        else
            puts "not used"
            create_p4_proxy
        end
    end
end

def load_current_resource
    @current_resource = Chef::Resource::KitchenP4P4proxy.new(@new_resource.name)
    @current_resource.name(@new_resource.name)
    @current_resource.ipv4_address(@new_resource.ipv4_address || "0.0.0.0" )
    @current_resource.port_num(@new_resource.port_num)
    @current_resource.cach_path(@new_resource.cach_path)
    @current_resource.p4p_version(@new_resource.p4p_version)
end

def port_used?(ipv4_address, port_num)
    system("lsof -i@#{ipv4_address}:#{port_num}", out: '/dev/null')
end

def create_p4_proxy
    append = true
    file = ::File.open('/opt/perforce-proxy/proxy.txt','r+')
    while (line = file.gets)
        next if  /#{@current_resource.name}/ !~ line.chomp
        append = false
        break
    end
    if append
        file.print("#{ @current_resource.name }\n")
        file.close
        deploy_p4_proxy
    end
end

# create p4 proxy script in folder
# add to rc.local
def deploy_p4_proxy
    p4pbin_root = "/opt/perforce-proxy/bin"
    p4plog_root = "/opt/perforce-proxy/logfiles"
    p4pcach_root = "/opt/perforce-proxy/caches"
    p4pbin = "#{p4pbin_root}/#{@current_resource.p4p_version}"
    raise "no p4pbinary !" if ! ::File.exist?(p4pbin)
    raise "dir exists" if ::File.exist?("#{p4pbin_root}/#{@current_resource.name}")
     raise "file exists"   if ::File.exist?("#{p4plog_root}/#{@current_resource.name}.log")
     raise "dir exists"   if ::File.exist?("#{p4pcach_root}/#{@current_resource.name}")
    FileUtils.mkdir
end

def create_p4p_bin

end


