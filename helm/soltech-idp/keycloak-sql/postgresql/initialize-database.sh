#!/bin/bash 

postgresql_host="${KEYCLOAK_DATABASE_HOST}"
postgresql_database="${KEYCLOAK_DATABASE_DATABASE}"
postgresql_username="${KEYCLOAK_DATABASE_USERNAME}"
postgresql_password="${KEYCLOAK_DATABASE_PASSWORD}"

if [[ "$( psql -h ${postgresql_host} -XtAc "SELECT 1 FROM pg_database WHERE datname='${postgresql_database}'" )" == "1" ]]
then
    database_exists="true"
else
    database_exists="false"
fi

if [[ "${database_exists}" == "true" && "${database_initialize}" == "true" ]]
then
    psql -h ${postgresql_host} -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${postgresql_database}' AND pid <> pg_backend_pid();"
fi

if [[ "${database_exists}" == "false" || "${database_initialize}" == "true" ]]
then
    psql -h ${postgresql_host} -tc "DROP DATABASE IF EXISTS ${postgresql_database};"
    psql -h ${postgresql_host} -tc "DROP ROLE IF EXISTS ${postgresql_username};"
    echo "Creating database ${postgresql_database} with owner ${postgresql_username}"
    psql -h ${postgresql_host} -tc "CREATE ROLE ${postgresql_username} LOGIN PASSWORD '${postgresql_password}' CREATEDB;"
    psql -h ${postgresql_host} -tc "GRANT ${postgresql_username} TO ${PGUSER};"
    psql -h ${postgresql_host} -tc "CREATE DATABASE ${postgresql_database} OWNER ${postgresql_username};"
else
    echo " "
    echo "Database exists and will be left intact."
fi

if [[ "${database_initialize}" == "false" ]]
then
    echo " "
    echo "Database tables will not be loaded."
    exit 0
fi

if [[ "${database_environment}" == "prod" ]]
then
    echo " "
    echo "Test seed scripts will not be executed."
    echo " "
fi

cd /sql

export PGPASSWORD="${postgresql_password}"

exit 0

#
# NOTE: After creating the dump, delete the "keycloak" user from the dump, so it's recreated with each intitialize to properly set the password.
# In addition to delet ethe user from, public.user_entity, also delete all dump records that have public.user_entity.id matching the "keycloak"
# user. Failure to do so will lock the "kecloak" user out of the application.
#

psql -h ${postgresql_host} -d ${postgresql_database} -U ${postgresql_username} -a -v "ON_ERROR_STOP=1" -f ./keycloak.sql || exit 1

# Seed for QA only
if [[ "${database_environment}" != "prod" ]]
then
    psql -h ${postgresql_host} -d ${postgresql_database} -U ${postgresql_username} -a -v "ON_ERROR_STOP=1" -f ./test-users.sql || exit 1
fi
