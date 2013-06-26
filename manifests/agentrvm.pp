class maestro_nodes::agentrvm(
  $agent_user = $maestro::params::agent_user,
) {

  include maestro_nodes::agent

  # rvm needs to be included after other classes that install packages that rvm also installs
  include rvm

  rvm::system_user { $agent_user: } ->
  rvm_system_ruby { 'ruby-1.8.7-p352':
    ensure      => 'present',
    default_use => true,
    require     => Package['git'],
  }

  # if we have a epel stage defined in parent nodes ensure it runs before installing rvm
  # as some rvm dependencies are in epel repositories
  if defined(Stage['epel']) {
    Stage['epel'] -> Stage['rvm-install']
  }
}
