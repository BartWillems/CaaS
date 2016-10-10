#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "You should run this script as root"
    exit 1
fi

echo "Enter a new  mysql user password for the user 'CaaS_admin'"
read -s PASSWORD;

echo "Repeat the password"
read -s PASSWORD_CONFIRM;

if [ $PASSWORD != $PASSWORD_CONFIRM ]
then
    echo "ERROR: Your passwords don't match"
    exit 1
fi

mysql -u root -e 'CREATE DATABASE CaaS CHARACTER SET utf8 COLLATE utf8_bin;'
mysql -u root -e "USE CaaS; CREATE USER 'CaaS_admin'@'localhost' IDENTIFIED BY '$PASSWORD';";
mysql -u root -e "GRANT ALL PRIVILEGES ON CaaS.* TO 'CaaS_admin'@'localhost' IDENTIFIED BY '$PASSWORD' WITH GRANT OPTION;";
mysql -u root -e "USE CaaS; CREATE TABLE users(username VARCHAR(24) PRIMARY KEY, password VARCHAR(60) NOT NULL);";

# TODO
# Insert password in /var/www/html/connection.php
if grep -q '$password = ' /var/www/html/connection.php; then
    sed -i "/\$password = /c\\$PASSWORD" /var/www/html/connection.php
else
    echo "\$password = $PASSWORD" >> /var/www/html/connection.php
fi
