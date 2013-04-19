class maestro_nodes::nginx::sonar(
  $sonar_port = $maestro_nodes::sonarserver::port,
  $hostname = $maestro_nodes::nginx::hostname,
  $ssl = $maestro_nodes::nginx::ssl,
) {
  nginx::resource::location { 'sonar_app':
    ensure => present,
    location => '/sonar',
    proxy => 'http://sonar_app',
    vhost => $hostname,
    ssl => $ssl,
    ssl_only => $ssl,
  }

  nginx::resource::upstream { 'sonar_app':
    ensure => present,
    members => "localhost:$sonar_port",
  }
}
