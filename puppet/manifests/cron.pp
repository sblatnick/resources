# == Resource: example::cron
#
# This resource configures cron jobs
#
# [cron]
#   Hash
#   Default: Empty Hash
#   Keys are files to be added to cron
#   Values are the contents of the cron files (fragment)
#
#   Puppet Example:
#
#   ::example::cron {'script' => @("SCRIPT"/L)
#       0 20 * * * root /path/to/script.sh
#       0 18 * * * root /path/to/script2.sh
#       #comment
#       30 0 * * * root /path/to/script3.sh
#     | SCRIPT
#   }
#
#   Hiera Example:
#
#   example::cron:
#     'script': |
#       0 20 * * * root /path/to/script.sh
#       0 18 * * * root /path/to/script2.sh
#       #comment
#       30 0 * * * root /path/to/script3.sh
define profile_example::cron (
  $content,
)
{
  notify{ "writing cron: ${name}": }
  file { "/etc/cron.d/${name}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => $content,
  }
}
