#check perforce account

package "git"

bash "add gitlab hosts record" do
    user "root"
    cwd "/tmp"
    code <<-EOH
        sed -i -e a"192.168.100.104  gitlab.example.com" /etc/hosts
    EOH
    not_if  "grep gitlab.example.com /etc/hosts"
end

group "perforce" do
    gid     2501
    not_if "id -g perforce"
    action :create
end

user "perforce" do
    comment "Perforce User"
    uid     2501
    gid     "perforce"
    home    "/home/perforce"
    shell   "/bin/bash"
    not_if  "id perforce"
    action :create
end

git "/opt/perforce" do
    repository "http://gitlab.example.com/jaywanglevelup/apac_p4.git"
    revision   "master"
    action     :sync
end
