Vagrant.configure("2") do |config|
  config.vm.boot_timeout     = 1800
  config.vm.box_check_update = true
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider :libvirt do |v, override|
    v.disk_bus = 'virtio'
    v.driver   = 'kvm'
    v.memory   = 2048
    v.cpus     = 2
  end
end
