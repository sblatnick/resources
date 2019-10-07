
#AGENT:
  #run puppet agent:
  puppet agent -tv

  #get managed resources by name:
  puppet resource package
  puppet resource service
  puppet resource file

  #get facts:
  facter -p #all
  facter -p variable_name

  #test facts or ruby logic:
  irb #interactive ruby
  require 'facter'

  #run facts:
  grep -h 'Facter.add' /var/lib/puppet/lib/facter/*.rb | grep -Po ':[^\)]*' | sed 's/^://' | xargs facter -p
  grep -Po 'Facter\.add\("[^"]*"\) do' /var/lib/puppet/lib/facter/*.rb | grep -Po '"[^"]*"' | xargs facter -p
