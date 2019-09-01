#!/bin/bash

# create random password
PASSWDDB="$(openssl rand -base64 12)"

echo $PASSWDDB

USER_NAME="devops-haptik"

# replace "-" with "_" for database username
MAINDB=${USER_NAME//[^a-zA-Z0-9]/_}

echo $MAINDB

mysql -u root<<MYSQL_SCRIPT
#CREATE DATABASE $MAINDB;

CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;
CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';
GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

exit 0

ALTER USER 'devops_haptik'@'localhost' IDENTIFIED BY 'aqLGi6kHJTv0KBuO';

UPDATE mysql.user SET authentication_string = PASSWORD('TYDl4uhnvQIQFn6l')
WHERE User = 'devops_haptik' AND Host = 'localhost';


CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO 'admin_user'@'localhost' IDENTIFIED BY 'devhaptik@0609';
FLUSH PRIVILEGES;
exit;

echo "
mysql -u root<<MYSQL_SCRIPT
CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;
CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';
GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
"

sed -i 's/password_here/M0jElAP\/XFoYkF5S/g' wp-config.php

sed -i "s/database_name_here/devops_haptik/" wp-config.php

sed -i "s/username_here/devops_haptik/g" wp-config.php