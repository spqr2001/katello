!#/bin/bash 

# Dependencies 
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-disksize

# Deploy Nodes 
vagrant up puppet.local && vagrant up client01.local client02.local yy

# Add Nodes to puppet.local 
vagrant ssh puppet.local -c "sudo /opt/puppetlabs/bin/puppet cert sign --all"
