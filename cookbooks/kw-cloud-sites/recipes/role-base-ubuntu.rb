#
# Cookbook Name:: kw-cloud-sites
# Recipe:: role-base-ubuntu
#
# Some Tools and Tasks Specific to Ubuntu
 
#
# Sysinfo
#
 
package "htop" do
  action :install
end
 
#
# Networking
#
 
%w{whois curl nmap traceroute iputils-ping netcat-openbsd tcpdump}.each do |package_name|
  package package_name do
    action :install
  end
end
 
#
# Unmount the Auto-mounted ephemerial drive
# Chef's mount resource seems to balk at this, so we're scripting it
#
 
bash "unmount_mnt" do
  code <<-EOH
    umount /mnt
  EOH
  user "root"
  cwd "/tmp"
  only_if "mount | grep /mnt"
end
 
#
# Create a data folder as the mount point for ephemeral drives
#
 
directory "/data" do
  owner "root"
  group "root"
  mode 0755
  action :create
end
