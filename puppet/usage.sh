
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