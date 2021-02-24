# Add custom facts here
#Installed: /var/lib/puppet/lib/facter/facts.rb

Facter.add(:users) do
  has_weight 100
  setcode do
    licenses = Facter::Core::Execution.exec("cut -d: -f1 /etc/passwd")
    licenses.split("\n") #make sure you use double quotes, or it won't match newlines
  end
end

#override core fact:
redhat = File.read("/etc/redhat-release") #CentOS release 6.10 (Final)
distro = redhat.split('release')[0].sub(' Linux','').strip
version = redhat[/(\d+\.\d+)/, 1]
major = version.split('.')[0]
minor = version.split('.')[1]

Facter['operatingsystem'].instance_eval("@value = '#{distro}'")
Facter['operatingsystemmajrelease'].instance_eval("@value = '#{major}'")
Facter['operatingsystemminrelease'].instance_eval("@value = '#{minor}'")
Facter['operatingsystemrelease'].instance_eval("@value = '#{version}'")
Facter['osfamily'].instance_eval("@value = 'RedHat'")

Facter['os'].instance_eval("@value['name'] = '#{distro}'")
Facter['os'].instance_eval("@value['release']['major'] = '#{major}'")
Facter['os'].instance_eval("@value['release']['minor'] = '#{minor}'")
Facter['os'].instance_eval("@value['release']['full'] = '#{version}'")
Facter['os'].instance_eval("@value['family'] = 'RedHat'")

#hiera doesn't support %{facts.os.name} yet:
Facter.add(:osname) do
  setcode do
    "#{distro}"
  end
end
Facter.add(:osrelease) do
  setcode do
    "#{version}"
  end
end

#Custom fact to determine if locally customized:
Facter.add(:settings_cfg_managed) do
  setcode do
    Facter::Core::Execution.exec("grep -q 'MANAGED BY PUPPET' /etc/settings.cfg && echo 'true' || echo 'false'")
  end
end