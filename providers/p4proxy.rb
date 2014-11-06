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
    @current_resource.cach_path_root(@new_resource.cach_path_root)
    @current_resource.p4p_version(@new_resource.p4p_version)
    @current_resource.server_port(@new_resource.server_port)
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
        deploy_p4_proxy
        file.write("#{ @current_resource.name }\n")
        file.close
    end
end

def deploy_p4_proxy
    p4pbin_root     = "/opt/perforce-proxy/bin"
    p4plog_root     = "/opt/perforce-proxy/logfiles"
    p4pbin          = "#{p4pbin_root}/#{@current_resource.p4p_version}"
    p4pscript       = "#{p4pbin_root}/#{@current_resource.name}/#{@current_resource.name}"
    p4plog          = "#{p4plog_root}/#{@current_resource.name}.log"
    p4pcach         = "#{@current_resource.cach_path_root}/#{@current_resource.name}"
    p4plocal_socket = "#{@current_resource.ipv4_address}:#{@current_resource.port_num}"

    raise "no p4pbinary !" if ! ::File.exist?(p4pbin)
    raise "#{p4pbin_root}/#{@current_resource.name} exists" if ::File.exist?("#{p4pbin_root}/#{@current_resource.name}")
    raise "#{p4plog} exists" if ::File.exist?("#{p4plog}")
    raise "#{p4pcach} exists"  if ::File.exist?("#{p4pcach}")
    rclocal = ::File.open('/etc/rc.local')
    found = false
    while (line = rclocal.gets)
        next if  /#{@current_resource.name}/ !~ line.chomp
        found = true
        break
    end
    rclocal.close
    raise "#{@current_resource.name} already in rc.local!" if found

    FileUtils.mkdir_p "#{p4pbin_root}/#{@current_resource.name}"
    FileUtils.mkdir_p "#{p4pcach}"
    FileUtils.copy_file(p4pbin, "#{p4pbin_root}/#{@current_resource.name}/p4p")
    ::File.open("#{p4pscript}", 'w') { |f| f.write("#{p4pbin_root}/#{@current_resource.name}/p4p -d -L #{p4plog} -p #{p4plocal_socket} -r #{p4pcach} -t #{@current_resource.server_port} \n") }
    FileUtils.chown_R 'perforce', 'perforce', "#{p4pcach}"
    FileUtils.chown_R 'perforce', 'perforce', "#{p4pbin_root}/#{@current_resource.name}"
    FileUtils.chmod_R 0755, "#{p4pbin_root}/#{@current_resource.name}"
    ::File.open("/etc/rc.local","a") { |f| f.write("su - perforce -c '#{p4pscript}' \n")}
end
