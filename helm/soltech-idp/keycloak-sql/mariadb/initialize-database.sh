#!/bin/bash

mariadb_host="${KEYCLOAK_DATABASE_HOST}"
mariadb_database="${KEYCLOAK_DATABASE_DATABASE}"
mariadb_username="${KEYCLOAK_DATABASE_USERNAME}"
mariadb_password="${KEYCLOAK_DATABASE_PASSWORD}"

mysql -h ${mariadb_host} -u ${MARIADB_ROOT_USER} -p${MARIADB_ROOT_PASSWORD} -e "DROP USER IF EXISTS '${mariadb_username}'@'%';"
mysql -h ${mariadb_host} -u ${MARIADB_ROOT_USER} -p${MARIADB_ROOT_PASSWORD} -e "DROP DATABASE IF EXISTS ${mariadb_database};"

mysql -h ${mariadb_host} -u ${MARIADB_ROOT_USER} -p${MARIADB_ROOT_PASSWORD} -e "CREATE USER '${mariadb_username}'@'%' IDENTIFIED BY '${mariadb_password}';"

mysql -h ${mariadb_host} -u ${MARIADB_ROOT_USER} -p${MARIADB_ROOT_PASSWORD} -e "CREATE DATABASE ${mariadb_database};"
mysql -h ${mariadb_host} -u ${MARIADB_ROOT_USER} -p${MARIADB_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${mariadb_database}.* TO '${mariadb_username}'@'%';"

if [[ -f "./seed-database.sql" ]]
then
   mysql -h ${mariadb_host} -u ${mariadb_username} -p${mariadb_password} < ./seed-database.sql
fi
