#!/bin/bash

 yum install java-1.8.0-openjdk.x86_64 -y
 yum update -y
 yum upgrade -y

yum install wget -y
 wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
 rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

 yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

 yum repolist

 yum install daemonize -y 

 yum install jenkins -y 

 systemctl start jenkins
 systemctl enable jenkins
 chkconfig jenkins on 

 yum install git -y