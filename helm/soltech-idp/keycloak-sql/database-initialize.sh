#!/bin/bash

cd /sql

export DATABASE_INITIALIZE="$1"
export DATABASE_ENVIRONMENT="$2"

echo "Database configuration started."
echo " "
echo "Database provider:    ${DATABASE_PROVIDER}"
echo "Database initialize:  ${DATABASE_INITIALIZE}"
echo "Database environment: ${DATABASE_ENVIRONMENT}"

./initialize-database.sh
