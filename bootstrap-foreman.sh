#!/bin/sh


	# Update system first
        sudo yum clean all 
	sudo yum update -y
	sudo yum -y install deltarpm

	# Resize VG / LV / FS 
        sudo partprobe
	(echo n; echo p; echo 3; echo ; echo ; echo w) | sudo fdisk /dev/sda
	sudo partprobe 
        sudo vgextend centos /dev/sda3
	sudo lvextend --resizefs -l +100%FREE /dev/mapper/centos-root

	sudo curl --remote-name --location https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
	sudo gpg --keyid-format 0xLONG --with-fingerprint ./RPM-GPG-KEY-puppet
	sudo rpm --import RPM-GPG-KEY-puppet
    	sudo yum -y install epel-release http://yum.theforeman.org/releases/1.16/el7/x86_64/foreman-release.rpm 
	sudo yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.5/katello/el7/x86_64/katello-repos-latest.rpm
	sudo yum -y localinstall https://yum.theforeman.org/releases/1.16/el7/x86_64/foreman-release.rpm
	sudo yum -y localinstall https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
	sudo yum -y localinstall https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	sudo yum -y install foreman-release-scl python-django
	sudo yum -y update
  	sudo yum -y install katello
	sudo foreman-installer --scenario katello --foreman-admin-password global --foreman-initial-location Kaiserslautern --foreman-initial-organization Holudeck


    	# Set-up firewall
    	sudo firewall-cmd --permanent --add-service=http
   	sudo firewall-cmd --permanent --add-service=https
    	sudo firewall-cmd --permanent --add-port=69/tcp
    	sudo firewall-cmd --permanent --add-port=67-69/udp
    	sudo firewall-cmd --permanent --add-port=53/tcp
    	sudo firewall-cmd --permanent --add-port=53/udp
    	sudo firewall-cmd --permanent --add-port=8443/tcp
    	sudo firewall-cmd --permanent --add-port=8140/tcp

    	sudo firewall-cmd --reload
    	sudo systemctl enable firewalld

    	# First run the Puppet agent on the Foreman host which will send the first Puppet report to Foreman,
    	# automatically creating the host in Foreman's database
    	sudo /opt/puppetlabs/bin/puppet agent --test --waitforcert=60

    	# Optional, install some optional puppet modules on Foreman server to get started...
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production puppetlabs-ntp
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production puppetlabs-git
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production puppetlabs-vcsrepo
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production garethr-docker
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production jfryman-nginx
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production puppetlabs-haproxy
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production puppetlabs-apache
    	sudo /opt/puppetlabs/bin/puppet module install -i /etc/puppetlabs/code/environments/production puppetlabs-java

    	# Reboot 
    	sudo init 6 