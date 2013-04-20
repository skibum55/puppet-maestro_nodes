class maestro_nodes::nginx(
  $hostname = $::fqdn,
  $maestro_port = $maestro::maestro::port,
  $ssl = false,
  $ssl_cert = undef,
  $ssl_key = undef,
) {
  include nginx

  if $ssl == true {
    $port = '443'

    file { '/etc/nginx/conf.d/default.conf':
      ensure => present,
      source => "puppet:///modules/eval/nginx/default.conf",
      notify => Service[nginx],
      require => Package[nginx],
    }
  } else {
    $port = '80'
  }

  nginx::resource::vhost { $hostname:
    ensure => present,
    ssl => $ssl,
    listen_port => $port,
    ssl_cert => $ssl_cert,
    ssl_key => $ssl_key,
    proxy => 'http://maestro_app',
  }

  nginx::resource::upstream { 'maestro_app':
    ensure => present,
    members => ["localhost:$maestro_port"],
  }
}