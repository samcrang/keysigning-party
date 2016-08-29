Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y signing-party

    cp -R /vagrant/conf/gnupg ~vagrant/.gnupg
    chown vagrant:vagrant ~vagrant/.gnupg
  SHELL
end
