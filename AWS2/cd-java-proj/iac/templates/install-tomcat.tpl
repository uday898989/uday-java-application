#!/bin/bash

hostnamectl set-hostname "tomcat.cloudbinary.io"
echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts
sudo apt-get update
sudo apt-get install git curl wget unzip tree -y 
sudo apt-get install software-properties-common -y 
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y 

cd /opt/
git clone https://github.com/kesavkummari/tomcat-role.git

cd tomcat-role

ls -lrt tomcat-setup.yml

ls -ld tomcat

apt update 

apt install awscli -y 

ansible-playbook tomcat-setup.yml

cd /usr/share/tomcat/webapps/

aws s3 cp s3://cloudbinary-demos/ROOT.war .

chmod 777 ROOT.war 

chown -R tomcat:tomcat ROOT.war
