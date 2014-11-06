package "lsof" do
    not_if "which lsof"
end

directory "/opt/perforce-proxy" do
    owner 'perforce'
    group 'perforce'
    action :create
    not_if "ls -ld /opt/perforce-proxy"
end

file "/opt/perforce-proxy/proxy.txt" do
    owner 'perforce'
    group 'perforce'
    action :create_if_missing
end

kitchen_p4_p4proxy "fcc_proxy_3333" do
    ipv4_address "127.0.0.1"
    port_num 3333
    cach_path_root "/mnt/perforce/cache"
    server_port "192.168.1.1:2222"
    action :create
end
