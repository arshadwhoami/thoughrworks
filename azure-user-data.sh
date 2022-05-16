#!/bin/bash
# Pre-Setup
sudo apt-get update 
sudo apt-get -y upgrade
sudo apt-get install Apache2 PHP texlive php-mbstring php-xml php-apcu php-horde-cache -y
#settingup mariadb
echo "Mariadb private IP is $1" > mariadb-private-ip.txt
sudo dnf -y install httpd php php-mysqlnd php-gd php-xml mariadb php-mbstring php-json vim epel-release wget
sudo systemctl enable httpd
#downloading mediawiki
wget https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.2.tar.gz
tar -zxf mediawiki-1.34.2.tar.gz

sudo mv mediawiki-1.34.2 /var/www/html/mediawiki/
sudo chown -R root:root /var/www/html/

sudo setenforce 0
sudo sed -i 's/=enforcing/=disabled/g' /etc/sysconfig/selinux

sudo systemctl restart httpd