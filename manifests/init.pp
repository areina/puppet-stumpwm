class stumpwm {
  require sbcl
  include boxen::config

  $stumpwm_root = "/home/${::boxen_user}/src/stumpwm"

  repository { $stumpwm_root:
    source => 'sabetts/stumpwm',
    user   => $::boxen_user,
  }

  file { [
          "/home/${::boxen_user}/.config",
          "/home/${::boxen_user}/.config/common-lisp",
          "/home/${::boxen_user}/.config/common-lisp/source-registry.conf.d",
          ]: 
    ensure => directory,
    owner  => $::boxen_user,
  }

  file { "/home/${::boxen_user}/.config/common-lisp/source-registry.conf.d/my-asdf.conf":
    ensure  => present,
    content => "(:tree '~/src/stumpwm/')",
    owner   => $::boxen_user,
  }

  file { [
          "/home/${::boxen_user}/.config/lxsession",
          "/home/${::boxen_user}/.config/lxsession/LXDE",
          ]:
    ensure => directory,
    owner  => $::boxen_user,
  }

  file { "/home/${::boxen_user}/.config/lxsession/LXDE/desktop.conf":
    ensure  => present,
    content => "[Session]\nwindow_manager=stumpwm",
    owner   => $::boxen_user,
  }

  exec { 'configure_and_compile':
    cwd     => $stumpwm_root,
    command => 'autoconf && ./configure && make',
    require => Repository[$stumpwm_root],
    before  => Exec['install'],
    user    => $::boxen_user,
    creates => "${stumpwm_root}/stumpwm"
  }

  exec { 'install':
    cwd     => $stumpwm_root,
    command => 'make install',
    user    => 'root',
    creates => '/usr/local/bin/stumpwm'
  }
}
