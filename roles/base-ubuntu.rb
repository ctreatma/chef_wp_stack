name "base-ubuntu"
description "Base role applied to all ubuntu nodes."
default_attributes()
override_attributes()
run_list(
  "recipe[apt::default]",
  "role[base]",
  "recipe[ubuntu::default]",
  "recipe[kw-cloud-sites::role-base-ubuntu]",
  "recipe[logrotate::default]"
)
