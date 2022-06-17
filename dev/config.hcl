consul {
  address = "127.0.0.1:8500"

  auth {
    enabled = false
  }
}

log_level = "warn"
log_file {
  path = "/var/log/consul-template.log"
  log_rotate_duration = "3h"
  log_rotate_max_files = 10
}


template {
  contents = "{{key \"configs/sw1\"}}"
  destination = "/etc/sonic/update.json"
  exec {
    command = "config load -y /etc/sonic/update.json && config save -y"
  }
}