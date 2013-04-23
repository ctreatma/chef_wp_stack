name "base"
description "Base role applied to all organization nodes."
default_attributes(
)
override_attributes(
  "chef_client" => {
    "init_style" => "init",
    "server_url" => "https://api.opscode.com/organizations/MYORG",
    "validation_client_name" => "MYORG-validator"
  }
)
run_list(
  "recipe[chef-client::delete_validation]",
  "recipe[chef-client::config]",
  "recipe[chef-client::service]",
  "recipe[build-essential]",
  "recipe[ntp]",
  "recipe[xfs]"
)
