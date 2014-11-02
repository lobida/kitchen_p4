kitchen_p4_p4proxy "fcc_proxy_3333" do
    ipv4_address "127.0.0.1"
    port_num 3333
    catch_path "/mnt/perforce/cache"
    action :create
end
