#!/bin/bash 

# Dependencies 
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-disksize

# Deploy Nodes 
vagrant up katello.local && vagrant up node01.local node02.local && 

# Add Nodes to puppet.local 
vagrant ssh katello.local -c "sudo /opt/puppetlabs/bin/puppet cert sign --all"
