#
# Cookbook Name:: kw-cloud-sites
# Recipe:: role-webserver
#
# Tailor apache/php to our specific requirements for site hosting, setup necessary drives
 
#
# Mount the first ephemeral drive, format XFS if necessary
#
 
directory "/data/web" do
  owner "root"
  group "root"
  recursive true
  mode 0755
end
 
# This only works on these instance types, otherwise you're on disk (Vagrant, etc.)
if node.attribute?('ec2') and %w{m1.medium m1.large m1.xlarge c1.xlarge cc1.4xlarge cc2.8xlarge cr1.8xlarge m2.xlarge m2.2xlarge m2.4xlarge hi1.4xlarge}.include? node['ec2']['instance_type']
 
  web_drive = "/dev/xvdb"
 
  execute "xfs_ephermeral0" do
    command "mkfs.xfs -f #{web_drive}"
    only_if "xfs_admin -l #{web_drive} 2>&1 | grep -qx 'xfs_admin: #{web_drive} is not a valid XFS filesystem (unexpected SB magic number 0x00000000)'"
  end
 
  mount "/data/web" do
    device web_drive
    fstype "xfs"
    options "rw,inode64"
    action [:mount, :enable]
  end
 
end
 
#
# Apache
#
 
# Make sure we're using the worker mpm
package "apache2-mpm-worker" do
  action :install
end
 
# Enable necessary build-in apache modules
%w{actions expires setenvif deflate filter expires rewrite ssl}.each do |module_name|
  apache_module module_name do
    enable true
  end
end
 
#
# Mod RPAF
#
 
package "libapache2-mod-rpaf" do
  action :install
end
 
apache_module "rpaf" do
  enable true
  conf true
end
 
#
# Mod SPDY
#
 
# Add Google Repository
#apt_repository "google-spdy" do
#  uri "https://dl-ssl.google.com/dl/linux/direct/mod-spdy-beta_current_amd64.deb"
#  distribution "stable"
#  components ["main"]
#  key "https://dl-ssl.google.com/linux/linux_signing_key.pub"
#end
 
# Install mod_spdy
#package "mod-spdy-beta" do
#  action :install
#end
 
# Enable it
#apache_module "spdy" do
#  enable true
#end
 
#
# PHP
#
 
# Install PHP-FPM
package "php5-fpm" do
  action :install
end
 
# Enable and start it
service "php5-fpm" do
  action [ :enable, :start ]
end
 
#
# Fastcgi
#
 
package "libapache2-mod-fastcgi" do
  action :install
end
 
# Enable the Apache Module
apache_module "fastcgi" do
  enable true
  conf true
end
 
# Install PHP Module Packages
["php5-mysql", "php5-curl", "php5-gd", "php-pear", "php-apc", "libssh2-php"].each do |pkg|
  package pkg do
    action :install
    notifies :restart, resources(:service => "php5-fpm"), :delayed
  end
end
