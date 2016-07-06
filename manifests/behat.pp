class forumone::behat ($version = '2.5') {

  include forumone::composer
  $phantomjs_version = "2.1.1"
  $phantomjs_file = "phantomjs-${phantomjs_version}-linux-x86_64.tar.bz2"

  $path = "/vagrant"
  $composer_lock = "/vagrant/tests/behat/composer.lock"

  if $path {

    file { "${path}/tests":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "777",
      require  => File["${path}"]
    }

    file { "${path}/tests/behat":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "777",
      require  => File["${path}/tests"],
      recurse  => true
    }

    file { "${path}/tests/test_results":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "777",
      require  => File["${path}/tests"]
    }

    class { '::phantomjs':
      package_version => '2.1.1',
      package_update => true,
      install_dir => '/usr/local/bin',
      source_dir => '/opt',
      timeout => 300
    }

    exec { 'web-starter-behat::composer':
      command     => "composer install",
      cwd         => "${path}/tests/behat",
      path        => ['/usr/bin', '/user/local/bin'],
      creates     => $composer_lock,
      require     => [Class['forumone::composer']],
      environment => ["COMPOSER_HOME=${::forumone::composer::home}"],
      timeout     => 1800
    }
  }

  file { "${path}/tests/behat/bin/behat":
    ensure   => link,
    owner    => $::host_uid,
    group    => $::host_gid,
    mode     => "777",
    target => "${path}/tests/behat/vendor/behat/behat/bin/behat"
  }


}
