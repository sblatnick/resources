#Hiera override default parameters:
  #role_example/manifests/init.pp:
    include ::profile_nagios_client
  #profile_nagios_client/manifests/load.pp:
    class { 'nagios::client':
      nrpe_version => $profile_nagios_client::nrpe_version
    }
    #NOTE: nothing passed for nrpe_pid_file
 
  #nagios/manifests/client.pp:
    class nagios::client (
    ...
      $nrpe_pid_file = $nagios::params::nrpe_pid_file,
    ...
    ) inherits ::nagios::params {...

  #params.pp:
    class nagios::params {
      $nrpe_pid_file = hiera('nagios::params::nrpe_pid_file','/var/run/nrpe.pid')
    }

  #Order of hiera lookup for nagios::params::nrpe_pid_file
    1. class name and variable joined by "::", so 'nagios::client::nrpe_pid_file'
    2. the right side of the =, the default so $nagios::params::nrpe_pid_file defined in params.pp

