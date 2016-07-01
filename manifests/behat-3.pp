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

    # Download drush
    exec { 'forumone::behat::phantomjs::download':
      command => "wget --directory-prefix=/opt -O ${phantomjs_file}  https://bitbucket.org/ariya/phantomjs/downloads/${phantomjs_file}",
      cwd     => '/opt',
      path    => '/usr/bin',
      creates => "/opt/${phantomjs_file}",
      timeout => 4800,
    }

    # extract from the archive
    exec { 'forumone::behat::phantomjs::extract':
      command => "tar -vxjf /opt/${phantomjs_file} -C /opt",
      path    => ["/bin", "/usr/bin"],
      require => Exec["forumone::behat::phantomjs::download"],
      creates => "/opt/phantomjs-${phantomjs_version}-linux-x86_64/README.md",
    }

    file { "/opt/phantomjs-${phantomjs_version}-linux-x86_64/":
      ensure  => directory,
      owner   => $::host_uid,
      require => Exec['forumone::behat::phantomjs::extract']
    }

    file { '/usr/local/bin/phantomjs':
      ensure  => 'link',
      target  => "/opt/phantomjs-${phantomjs_version}-linux-x86_64/bin/phantomjs",
      require => Exec['forumone::behat::phantomjs::extract']
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
