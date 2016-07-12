class forumone::behat ($version = '~3.0.4') {

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

    file { "${path}/tests/behat":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests"]
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

    file { "${path}/tests/behat/files":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"]
    }

    file { "${path}/tests/behat/test_results":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"]
    }

    file { "${path}/tests/behat/patches":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"]
    }

    file { "${path}/tests/behat/patches/drupal-extension-login.patch":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat/patches"],
      content  => template("forumone/behat/patches/drupal-extension-login.patch.erb")
    }

    file { "${path}/tests/behat/features":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
    }

    file { "${path}/tests/behat/features/bootstrap":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat/features"],
    }

    file { "${path}/tests/behat/features/TESTS":
      ensure   => directory,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat/features"],
    }

    file { "${path}/tests/behat/features/TESTS/test.feature":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat/features/TESTS"],
      replace  => no,
      content  => template("forumone/behat/features/TESTS/test.feature.erb")
    }

    file { "${path}/tests/behat/features/TESTS/test-js.feature":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat/features/TESTS"],
      replace  => no,
      content  => template("forumone/behat/features/TESTS/test-js.feature.erb")
    }

    file { "${path}/tests/behat/features/bootstrap/FeatureContext.php":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat/features/bootstrap"],
      replace  => no,
      content  => template("forumone/behat/features/bootstrap/FeatureContext.php.erb")
    }

    file { "${path}/tests/behat/behat.yml":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      replace  => no,
      require  => File["${path}/tests/behat"],
      content  => template("forumone/behat/behat.yml.erb")
    }

    file { "${path}/tests/behat/behat.remote.yml":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      replace  => no,
      content  => template("forumone/behat/behat.remote.yml.erb")
    }

    file { "${path}/tests/behat/composer.json":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      content  => template("forumone/behat/composer.json.erb")
    }

    file { "${path}/tests/behat/nodeconfig.server.json":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      content  => template("forumone/behat/nodeconfig.server.json.erb")
    }

    file { "${path}/tests/behat/nodeconfig.mac.json":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      replace  => no,
      content  => template("forumone/behat/nodeconfig.mac.json.erb")
    }

    file { "${path}/tests/behat/nodeconfig.windows.json":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      replace  => no,
      content  => template("forumone/behat/nodeconfig.windows.json.erb")
    }

    file { "${path}/tests/behat/nodeconfig.linux.json":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      replace  => no,
      content  => template("forumone/behat/nodeconfig.linux.json.erb")
    }

    file { "${path}/tests/behat/README.md":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      content  => template("forumone/behat/README.md.erb")
    }

    file { "${path}/tests/behat/selenium-server-standalone-2.48.2.jar":
      ensure   => present,
      owner    => $::host_uid,
      group    => $::host_gid,
      mode     => "644",
      require  => File["${path}/tests/behat"],
      source   => ["/etc/puppet/modules/forumone/templates/behat/selenium-server-standalone-2.48.2.jar"]
    }

    exec { 'web-starter-behat::composer':
      command     => "composer install",
      cwd         => "${path}/tests/behat",
      path        => ['/usr/bin', '/user/local/bin'],
      creates     => $composer_lock,
      require     => [Class['forumone::composer'], File["${path}/tests/behat/composer.json"]],
      environment => ["COMPOSER_HOME=${::forumone::composer::home}"],
      timeout     => 1800
    }
  }

}
