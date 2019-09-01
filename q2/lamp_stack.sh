#!/bin/bash

# Update Package Index
apt-get update

# Install Apache2, MySQL, PHP
apt install -y apache2 mysql-server php php-mysql libapache2-mod-php php-cli systemd ufw xdg-open xdg-utils

# Allow to run Apache on boot up


# Restart Apache Web Server
service apache2 start

service mysql start
# Adjust Firewall

# Allow Read/Write for Owner
sudo chmod -R 0755 /var/www/html/

cd /var/www/html
wget -c http://wordpress.org/latest.zip
unzip latest.zip
chown -R www-data:www-data wordpress
rm latest.zip


cd /var/www/html/wordpress
mv wp-config-sample.php wp-config.php

# create random password
PASSWORD="devhaptik@0609"

DBNAME="wordpress"

USERNAME="admin_user"

# replace "-" with "_" for database username
echo "
mysql -u root<<MYSQL_SCRIPT
CREATE DATABASE ${DBNAME};
GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
"

mysql -u root<<MYSQL_SCRIPT
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'admin_user'@'localhost' IDENTIFIED BY 'devhaptik@0609';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

cd /var/www/html/wordpress/

sed -i "s/password_here/${PASSWORD}/g" wp-config.php

sed -i "s/database_name_here/${DBNAME}/" wp-config.php

sed -i "s/username_here/${USERNAME}/g" wp-config.php

/etc/apache2/sites-available

sed -i 's#/var/www/html# /var/www/html/wordpress#' 000-default.conf