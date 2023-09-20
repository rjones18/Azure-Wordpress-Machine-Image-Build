#!/bin/bash

# Install Defender for Endpoint Agent
sudo apt-get update && sudo apt-get install curl -y
curl -o microsoft-mdatp-public.key https://packages.microsoft.com/keys/microsoft.asc
sudo apt-key add microsoft-mdatp-public.key
curl -o mdatp.list https://packages.microsoft.com/config/ubuntu/18.04/prod.list
sudo mv mdatp.list /etc/apt/sources.list.d/
sudo apt-get update
sudo apt-get install mdatp
sudo systemctl start mdatp



# Install apache2 along with other packages
sudo apt-get install -y apache2 php php-mysql php-curl mysql-client libapache2-mod-php unzip nano

# Download latest version of Wordpress from site and unzip file
cd /var/www/ && sudo wget https://wordpress.org/latest.zip && sudo unzip latest.zip && cd wordpress && touch wp-config.php

# Edit 000-default.conf file to update default path
# Assuming you have the 000-default.conf.tpl file in the same directory where this script will be run
sudo bash -c 'cat <<EOF > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/wordpress

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

# Restart apache service
sudo systemctl restart apache2

# Update permissions
sudo chown -R www-data:www-data /var/www/wordpress
