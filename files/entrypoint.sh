#!/bin/bash
set -e

#DATABASE INIT/CONFIG
mysql -h $DB_HOST -u$DB_USER -p$DB_PW -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_swedish_ci;"
mysql -h $DB_HOST -u$DB_USER -p$DB_PW -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER' IDENTIFIED BY '$DB_PW';"

cd $CA_PROVIDENCE_DIR/media/collectiveaccess && mkdir -p tilepics



sweep() {
	local ca="$ca"
	sed -i "s@define(\"__CA_DB_HOST__\", 'localhost');@define(\"__CA_DB_HOST__\", \'$DB_HOST\');@g" setup.php
	sed -i "s@define(\"__CA_DB_USER__\", 'db_user');@define(\"__CA_DB_USER__\", \'$DB_USER\');@g" setup.php
	sed -i "s@define(\"__CA_DB_PASSWORD__\", 'db_password');@define(\"__CA_DB_PASSWORD__\", \'$DB_PW\');@g" setup.php
	sed -i "s@define(\"__CA_DB_DATABASE__\", 'db_name');@define(\"__CA_DB_DATABASE__\", \'$DB_NAME\');@g" setup.php
}
cd $CA_PROVIDENCE_DIR
ca='pro'
sweep $ca
#cd $CA_PAWTUCKET_DIR
#ca='paw'
#sweep $ca

rm -f /var/run/apache2/apache2.pid

exec "$@"
