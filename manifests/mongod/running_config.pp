# PRIVATE CLASS: do not call directly
class mongodb::mongod::running_config {

  $aso = $::mongodb::mongod::auth_schema_override

  # We don't support mongo versions < 2.6.0
  if $aso >= 3 {
    if $::mongodb_isprimary == "true" {
      exec { "set authschema version to ${aso}":
        command => "/usr/bin/mongo admin --quiet --eval 'var s=db.system.version.findOne({\"_id\":\"authSchema\"});s.currentVersion=${aso};db.system.version.save(s)'",
        unless  => "/usr/bin/mongo admin --quiet --eval 'if(db.system.version.findOne({\"_id\":\"authSchema\"}).currentVersion==${aso}){print(\"true\")}' | grep -qw true",
      }
    }
  }

}
