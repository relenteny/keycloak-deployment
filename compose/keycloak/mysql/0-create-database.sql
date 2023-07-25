DROP USER IF EXISTS 'keycloak'@'localhost';
DROP USER IF EXISTS 'keycloak'@'%';
DROP DATABASE IF EXISTS keycloak;

CREATE USER 'keycloak'@'localhost' IDENTIFIED BY 'keycloak';
CREATE USER 'keycloak'@'%' IDENTIFIED BY 'keycloak';

CREATE DATABASE keycloak;
GRANT ALL PRIVILEGES ON keycloak.* TO 'keycloak'@'%';
GRANT ALL PRIVILEGES ON keycloak.* TO 'keycloak'@'localhost';
