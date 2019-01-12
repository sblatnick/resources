# == Class: profile_example
#
# Example puppet class.
#
# === Parameters
#
# All parameters are pulled from Hiera.
#
class profile_example {
  #handle all package pre-requisites from hiera:
  ensure_packages(hiera_hash('preinstall::packages', {}), {'ensure' => 'present'})
  create_resources('profile_example::cron', resource_restructure(hiera_hash('example::cron', {}), "content"))

  file { '/usr/libexec/example':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    tag    => 'example',
  }
  $example_setup_fragment = hiera('setup::fragment', '')
  if "${example_setup_fragment}" != '' {
    file { '/usr/lib/systemd/system/setup.service':
      ensure  => 'present',
      path    => '/usr/lib/systemd/system/setup.service',
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
      content => template('profile_example/setup.service.erb'),
      force => true,
      replace => true,
      before => Service['setup'],
    }
    file { '/usr/libexec/example/setup':
      ensure  => 'present',
      path    => '/usr/libexec/example/setup',
      owner   => 'root',
      group   => 'root',
      mode    => 0744,
      content => template('profile_example/setup.erb'),
      force => true,
      replace => true,
      require => File['/usr/libexec/example'],
      notify => Service['setup'],
    }
    service { 'setup':
      enable => true,
    }
  }

  file { '/etc/example':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    tag    => 'example',
  }
  create_resources('file', resource_restructure(hiera_hash('example::configs', {}), "content"), {
    ensure  => 'present',
    replace => 'true',
    owner => 'root',
    group => 'root',
    mode => 0755,
    require => File['/etc/example'],
    tag => 'example',
  })

  #symlink:
  file { '/etc/localtime':
    ensure => 'link',
    target => '/usr/share/zoneinfo/US/Pacific',
    force => true,
    replace => true,
    tag => 'example',
  }

  $services_common = hiera('services::common', 'true')
  if "${services_common}" == 'true' {
    $dynamic_properties = hiera_array('dyanamic_properties', [])
    $directories = hiera_array('directories', [])
    file { $directories:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      tag    => 'example',
      require  => File['/usr/libexec/example'],
      before => [
        File['environment'],
        File[$dynamic_properties],
      ],
    }

    file { $dynamic_properties:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
      content => '',
      tag     => 'example',
    }

    $pools = hiera('pools')
    file { 'example.properties':
      ensure  => 'present',
      path    => '/etc/example.properties',
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
      content => template('profile_example/example.properties.erb'),
      tag     => 'example',
    }

    $javaargs = hiera_array('javaargs', [])
    $env = hiera_hash('env', {})

    file { 'environment':
      ensure  => 'present',
      path    => '/usr/libexec/example/environment',
      owner   => 'root',
      group   => 'root',
      mode    => 0755,
      content => template("profile_example/environment.erb"),
      tag     => 'example',
    }

    create_resources("mount", hiera_hash('mounts', {}), {
      ensure  => 'mounted',
      atboot  => true,
      fstype  => 'nfs',
      options => 'intr,noatime,soft',
      dump    => '0',
      pass    => '0',
    })

    create_resources('file', resource_restructure(hiera_hash('links', {}), "target"), {
      ensure => 'link',
      force => true,
      replace => true,
      tag => 'example_ln',
    })

    create_resources('file', p12_restructure(hiera_hash('keystores', {})), {
      owner => 'root',
      group => 'root',
      mode => 0644,
      tag => 'example',
    })

    $services_refresh = hiera('services::refresh', 'true')
    if "${services_refresh}" == 'true' {
      Package<||>
        ~> File<|tag == 'example'|>
        ~> Mount<|fstype == 'nfs'|>
        ~> File<|tag == 'example_ln'|>
        ~> Service<||>
    }
    else {
      Package<||>
        ~> File<|tag == 'example'|>
        ~> Mount<|fstype == 'nfs'|>
        ~> File<|tag == 'example_ln'|>
    }
  }

}
