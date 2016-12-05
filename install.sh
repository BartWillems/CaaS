#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "You should run this script as root"
    exit 1
fi


echo -n "Enter a new  mysql user password for the user 'CaaS_admin': "
read -s PASSWORD;

echo "Repeat the password: "
read -s PASSWORD_CONFIRM;

echo '';

if [ $PASSWORD != $PASSWORD_CONFIRM ]
then
    echo "ERROR: Your passwords don't match"
    exit 1
fi

mysql -u root -e 'CREATE DATABASE CaaS CHARACTER SET utf8 COLLATE utf8_bin;'
mysql -u root -e "USE CaaS; CREATE USER 'CaaS_admin'@'localhost' IDENTIFIED BY '$PASSWORD';";
mysql -u root -e "GRANT ALL PRIVILEGES ON CaaS.* TO 'CaaS_admin'@'localhost' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;";
mysql -u root -e "USE CaaS; CREATE TABLE users(username VARCHAR(24) PRIMARY KEY, password VARCHAR(60) NOT NULL);";
mysql -u root -e "USE CaaS; CREATE TABLE containers(fq_container_name VARCHAR(60) NOT NULL, username VARCHAR(24) NOT NULL, container_name VARCHAR(60) NOT NULL, container_id INT PRIMARY KEY);";
mysql -u root -e "USE CaaS; create table admin_approval(username VARCHAR(24) PRIMARY KEY);";
mysql -u root -e "USE CaaS; create table configuration(port_range VARCHAR(12) PRIMARY KEY);";
mysql -u root -e "USE CaaS; INSERT INTO configuration values('0-0');";

git clone https://github.com/BartWillems/CaaS_website html

# Insert password in /var/www/html/connection.php
if grep -q '$db_password = ' html/php_functions/connection.php; then
    sed -i "/\$db_password = /c\$db_password  = '$PASSWORD';" html/php_functions/connection.php
else
    echo "\$db_password = $PASSWORD" >> html/php_functions/connection.php
fi

echo "Downloading the container config files..."
git clone https://github.com/BartWillems/docker-ubuntu-vnc-desktop /opt/docker-ubuntu-vnc-desktop
sudo chown -R www-data /opt/docker-ubuntu-vnc-desktop
ln -s $(pwd)/containerManager.sh /usr/local/bin/containerManager.sh
chmod +x /usr/local/bin/containerManager.sh
