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
      mode     => "644",
      require  => File["${path}"]
    }

    file { "${path}/tests/behat-3":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests"],
      recurse  => true
    }

    file { "${path}/tests/test_results":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests"]
    }

    phantomjs::install { 'phantomjs_install':
      target_dir           => "/usr/local/",
      version              => '2.1.1',
      http_repository      => "https://phantomjs.googlecode.com/files",
      packaging            => 'tar.bz2',
      overwrite            => false,
      is_default_phantomjs => true
    }

    exec { 'web-starter-behat::composer':
      command     => "composer install",
      cwd         => "${path}/tests/behat-3",
      path        => ['/usr/bin', '/user/local/bin'],
      creates     => $composer_lock,
      require     => [Class['forumone::composer'], File["${path}/tests/behat-3/composer.json"]],
      environment => ["COMPOSER_HOME=${::forumone::composer::home}"],
      timeout     => 1800
    }
  }

}
