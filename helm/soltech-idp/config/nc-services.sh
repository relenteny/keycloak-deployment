#!/bin/sh

echo "Validating support services"

if [[ -n "${DATABASE_HOST}" ]]
then
    echo " "
    echo "Waiting for Database..."
    until nc -w 5 -z ${DATABASE_HOST} ${DATABASE_PORT} 2>/dev/null; do echo "Waiting for database at ${DATABASE_HOST}."; done;
    echo "Database available."
fi

echo "Support services are available."
