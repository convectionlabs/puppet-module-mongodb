# PRIVATE CLASS: do not use directly
#
# Generic Mongo server settings
#
class mongodb::server {

  $ensure               = true
  $user                 = 'mongodb'
  $group                = 'mongodb'
  $config               = '/etc/mongodb.conf'
  $package_name         = 'mongodb-server'
  $package_version      = undef
  $auth_schema_override = 0
  $hieramerge           = false

  $service_name         = 'mongod'
  $service_status       = undef
  $service_provider     = undef

  # Internal use: yaml config file generation
  $sorted_yaml = "---
<% @settings.keys.sort.each do |key| -%>
<%= key %>:
<% @settings[key].keys.sort.each do |param| -%>
  <%= param %>: <%= @settings[key][param] %>
<% end -%>
<% end -%>"

}
