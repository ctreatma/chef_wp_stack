Vagrant.configure("2") do |config|
  config.vm.box = "precise64"

  config.vm.network :private_network, ip: "192.168.33.10"
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = 'cookbooks'
    chef.roles_path = 'roles'
    chef.data_bags_path = 'data_bags'

    chef.add_role 'base-ubuntu'
    chef.add_role 'webserver'
  end
end
