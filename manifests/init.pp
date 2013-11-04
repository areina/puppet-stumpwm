class stumpwm {
  require sbcl
  include boxen::config

  $stumpwm_root = "/home/${::boxen_user}/src/stumpwm"

  repository { $stumpwm_root:
    source => 'sabetts/stumpwm',
    user   => $::boxen_user,
  }
}
