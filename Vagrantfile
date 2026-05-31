Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-24.04"
    config.vm.network  "private_network", ip: "192.168.56.10"
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "8196"
        vb.cpus = 4
    end
    # Share the project directory (Git repo) into the VM
    # Host: current directory (where Vagrantfile is)
    # Guest: /home/vagrant/gridsensor-simulator
    config.vm.synced_folder ".", "/home/vagrant/gridsensor-simulator"
    config.vm.provision "shell", path: "provision.sh"
end