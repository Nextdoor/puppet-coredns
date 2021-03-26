# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include coredns::service
class coredns::service (
  Boolean $enabled  = true
){
  if $enabled {
    $_service_ensure = running
    $_service_enable = true
  } else {
    $_service_ensure = stopped
    $_service_enable = false
  }

  include 'systemd'
  systemd::unit_file {'coredns.service':
    content => template('coredns/service.erb'),
    active  => $_service_enable,
    enable  => $_service_enable,
  }
  ~> service {'coredns':
    ensure => $_service_ensure,
    enable => $_service_enable,
  }
}
