# Keycloak Docker Compose Deployment

***Currently, this deployment only supports MySQL as the database***

## Deployment Parameters

### Keycloak

* Access URL: ```http://localhost:8080```
* Keycloak Admin User: ```keycloak```
* Keycloak Admin Password: ```Keycloak123!```

### MySQL

* MySQL Exposed Port: ```3306```
* MySQL Root Password: ```mysql```
* Keycloak Database Name: ```keycloak```
* Keycloak Database User: ```keycloak```
* Keycloak Database Password: ```keycloak```

## Application Deployment

This Docker Compose configuration includes installing and configuring MYSQL locally.

### Deploying

```docker compose up -d```

### Stopping

```docker compose stop```

### Stopping and Resetting the Environment

```docker compose down --remove-orphans -v```
