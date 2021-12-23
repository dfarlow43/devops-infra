#!/bin/bash

 yum update -y
 yum upgrade -y

yum install wget -y
 yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

 yum repolist

yum install python38.x86_64 python38-devel.x86_64 python38-pip.noarch openssl ansible -y
yum install ansible
yum install daemonize -y 

sudo su -
sudo useradd ansibleadmin
sudo echo "ansibleansible" | passwd --stdin ansibleadmin
# modify the sudoers file at /etc/sudoers and add entry
echo 'ansibleadmin     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ec2-user     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart
# yum install git -y