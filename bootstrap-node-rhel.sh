#!/bin/sh



    # Puppet GPG 

    sudo curl --remote-name --location https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
    sudo rpm --import RPM-GPG-KEY-puppet

    # Metadata 
    sudo yum -y clean all 

    # Katello-Agent 
    sudo yum install -y https://fedorapeople.org/groups/katello/releases/yum/3.5/client/el7/x86_64/katello-client-repos-latest.rpm
    sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo yum -y update 
    sudo yum -y install  subscription-manager
    sudo rpm -Uvh http://puppet.local/pub/katello-ca-consumer-latest.noarch.rpm
    sudo yum -y  install katello-agent
    sudo subscription-manager register --org="Holudeck" --activationkey="holudeck"
    wget http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
    sudo hammer gpg create  --key RPM-GPG-KEY-CentOS-7 --name "Centos7"  --organization "Holudeck"

    # Services

    sudo systemctl start goferd
    sudo systemctl enable goferd

    
    # Puppet Conf 
    echo "" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null && \
    echo "    server = puppet.local" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null && \
    echo "    runinterval = 120s" | sudo tee --append /etc/puppetlabs/puppet/puppet.conf 2> /dev/null

    sudo service puppet restart  
    sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
    sudo /opt/puppetlabs/bin/puppet agent --enable

    # Unless you have Foreman autosign certs, each agent will hang on this step until you manually
    # sign each cert in the Foreman UI (Infrastrucutre -> Smart Proxies -> Certificates -> Sign)
    # Alternative, run manually on each host, after provisioning is complete...
    #sudo /opt/puppetlabs/bin/puppet agent --test --waitforcert=60
