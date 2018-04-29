server stuff:

mosh

backup:
    borg backup
    (bacula)

file sharing:
    nextcloud
    syncthing
    transmission (torrent)

file versioning/dev:
    gitweb
    gitlab
    gitolite

privacy:
    openVPN

project hosting:
    apache
    jekyll
    certbot


mailutils

#! /bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

---------------------------------------------

#enable jessie-backports

echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

---------------------------------------------

#mosh

sudo apt-get install mosh

---------------------------------------------

#borgBackup

sudo apt-get install borgbackup -t jessie-backports -y

---------------------------------------------

#nextcloud

##apache

apt-get install apache2 mariadb-server -y

systemctl start apache2
systemctl enable apache2
systemctl start mysql
systemctl enable mysql


##mariadb

mysql_secure_installation
!!!

##php
apt-get install php7.0-xml php7.0 php7.0-cgi php7.0-cli php7.0-gd php7.0-curl php7.0-zip php7.0-mysql php7.0-mbstring wget unzip -y

##nextcloud

wget https://download.nextcloud.com/server/releases/nextcloud-12.0.3.zip
wget https://download.nextcloud.com/server/releases/nextcloud-12.0.3.zip.sha256
sha256sum -c nextcloud-12.0.3.zip.sha256 < nextcloud-12.0.3.zip
unzip nextcloud-12.0.3.zip

mv nextcloud /var/www/html
chown -R www-data:www-data /var/www/html/nextcloud

vi /etc/apache2/sites-available/nextcloud.conf
!!!

ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf

a2enmod rewrite

a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime

service apache2 restart

---------------------------------------------

#syncthing

# Add the release PGP keys:
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

# Add the "stable" channel to your APT sources:
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing

---------------------------------------------

#transmission

sudo apt-get install transmission-cli transmission-daemon -y

---------------------------------------------

#gitweb

sudo apt-get install gitweb -y

---------------------------------------------

#openVPN

sudo apt-get install openvpn -y

---------------------------------------------

#apache

sudo apt-get install apache2 -y

---------------------------------------------

#jekyll

sudo apt-get install ruby ruby-dev rubygems -y
gem install jekyll bundler

---------------------------------------------
#certbot

sudo apt-get install python-certbot-apache -t jessie-backports
sudo certbot --apache

sudo apt install cronie

#!/bin/bash

#https://askubuntu.com/questions/58575/add-lines-to-cron-from-script
#line="* * * * * /path/to/command"
#(crontab -u userhere -l; echo "$line" ) | crontab -u userhere -

line="@daily certbot renew"
(crontab -u pi -l; echo "$line" ) | crontab -u pi -

---------------------------------------------
#/etc/init/jekyll.conf

line="@reboot start jekyll"
(crontab -u pi -l; echo "$line" ) | crontab -u pi -

description "Jekyll"
author      "Christopher Rung<clrung@gmail.com>"
# adapted from https://gist.github.com/hazanjon/8725263\#file-jekyll-conf
# https://www.christopherrung.com/tutorial/2015/05/07/apache-and-jekyll/

env SITENAME=liambeckman.com
env SOURCE=/home/pi/Documents/code/lbeckman314.github.io
env SITEDIR=/var/www/html/liambeckman.com/public_html/
env JEKYLL=`which jekyll`

#Make sure mounting is completed before starting
start on started mountall
stop on shutdown

# Automatically Respawn:
respawn
respawn limit 99 5

script
    export HOME="/root"
    export LANG="en_US.UTF-8"
    exec $JEKYLL build --watch --incremental -s $SOURCE -d $SITEDIR >> /var/log/jekyll-$SITENAME.log
end script
