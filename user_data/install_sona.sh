#!/bin/bash

 yum install java-1.8.0-openjdk.x86_64 -y
 yum update -y
 yum upgrade -y

yum install wget -y

cd /opt/
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz

tar zxvf latest-unix.tar.gz

yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
mv nexus-3.* nexus3

chown -R ec2-user:ec2-user nexus3/ sonatype-work/

cd /opt/nexus3/bin/
touch nexus.rc
echo 'run_as_user="ec2-user"'|sudo tee -a /opt/nexus3/bin/nexus.rc

ln -s /opt/nexus3/bin/nexus /etc/init.d/nexus
cd /etc_init.d

chkconfig --add nexus
chkconfig --levels 345 nexus on

sudo su - ec2-user
service nexus start


yum repolist

