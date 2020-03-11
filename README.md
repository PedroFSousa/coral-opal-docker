# Opal Docker

This repository contains the source code for building an [Opal](https://www.obiba.org/pages/products/opal/) Docker image based on the [original Opal image from OBiBa](https://github.com/obiba/docker-opal), modified to:
* support the use of Docker secrets for passwords;
* allow for the configuration of the maximum amount of memory allocated to Opal;
* configure MySQL (tabular) databases by default;
* create `opal-administrator` and `opal-create-project` permission groups;
* automatically add custom Opal taxonomies.

## Building
After every commit, GitLab CI automatically builds the image and pushes it into INESC TEC's Docker Registry. The version tag of the image is determined from a string matching `##x.x.x##` on the commit message.

Alternatively, an image can be built locally by running:
`docker build -t opal-docker .`

## Setting Up
**Environment Variables**  
The following environment variables are available:

* `OPAL_ADMINISTRATOR_PASSWORD` is the password for the administrator account of the Opal server;
* `OPAL_JAVA_MEM` is the maximum amount of memory allocated to Opal (in gigabytes);
* `MYSQLIDS_PORT_3306_TCP_ADDR` and `MYSQLIDS_PORT_3306_TCP_PORT` are the address and port of the MySQL server where the IDs will be stored;
* `MYSQLIDS_DATABASE` is the name of the IDs database;
* `MYSQLIDS_USER` and `MYSQLIDS_PASSWORD` are the credentials Opal will use to connect to the IDs database.
* `MYSQLDATA_PORT_3306_TCP_ADDR` and `MYSQLDATA_PORT_3306_TCP_PORT` are the address and port of MySQL server where the data will be stored;
* `MYSQLDATA_DATABASE` is the name of the data database;
* `MYSQLDATA_USER` and `MYSQLDATA_PASSWORD` are the credentials Opal will use to connect to the data database.
* `RSERVER_PORT_6312_TCP_ADDR` and `RSERVER_PORT_6312_TCP_PORT` are the address and port of the R server;
* `AGATE_PORT_8444_TCP_ADDR` and `AGATE_PORT_8444_TCP_PORT` are the address and port of the Agate server;
* `DSBASE_VERSION` is the version of the DataSHIELD base package.

If you are using Docker Swarm, you can instead set the following variables to enable Docker secrets:
* `OPAL_ADMINISTRATOR_PASSWORD_FILE`
* `MYSQLIDS_PASSWORD_FILE`
* `MYSQLDATA_PASSWORD_FILE`

**Volumes**  
Volumes can be mounted to different parts of the container:
* `/usr/share/opal/taxonomies` where you can place any Opal taxonomies (JSON format) that you may want to add;
* `/srv` where data that should be persisted is stored.

## Running

Create a `docker-compose.yml` file (examples bellow) and run `docker-compuse up`.

**Basic Example:**
```yml
version: '3.2'

services:
  opal:
    image: docker-registry.inesctec.pt/coral/coral-docker-images/coral-opal-docker:1.3.0
    container_name: opal
    environment:
    - OPAL_ADMINISTRATOR_PASSWORD=<INSERT_VALUE_HERE>
    - OPAL_JAVA_MEM=<INSERT_VALUE_HERE>
    - MYSQLIDS_PORT_3306_TCP_ADDR=<INSERT_VALUE_HERE>
    - MYSQLIDS_PORT_3306_TCP_PORT=<INSERT_VALUE_HERE>
    - MYSQLIDS_DATABASE=<INSERT_VALUE_HERE>
    - MYSQLIDS_USER=<INSERT_VALUE_HERE>
    - MYSQLIDS_PASSWORD=<INSERT_VALUE_HERE>
    - MYSQLDATA_PORT_3306_TCP_ADDR=<INSERT_VALUE_HERE>
    - MYSQLDATA_PORT_3306_TCP_PORT=<INSERT_VALUE_HERE>
    - MYSQLDATA_DATABASE=<INSERT_VALUE_HERE>
    - MYSQLDATA_USER=<INSERT_VALUE_HERE>
    - MYSQLDATA_PASSWORD=<INSERT_VALUE_HERE>
    - RSERVER_PORT_6312_TCP_ADDR=<INSERT_VALUE_HERE>
    - RSERVER_PORT_6312_TCP_PORT=<INSERT_VALUE_HERE>
    - DSBASE_VERSION=5.1.0
    - AGATE_PORT_8444_TCP_ADDR=<INSERT_VALUE_HERE>
    - AGATE_PORT_8444_TCP_PORT=<INSERT_VALUE_HERE>
    volumes:
    - <PATH_TO_TAXONOMIES>:/usr/share/opal/taxonomies
    - opal:/srv

volumes:
  opal:
```
**Docker Swarm Example:**
```yml
version: '3.2'

services:
  opal:
    image: docker-registry.inesctec.pt/coral/coral-docker-images/coral-opal-docker:1.3.0
    container_name: opal
    environment:
    - OPAL_ADMINISTRATOR_PASSWORD_FILE=/run/secrets/OPAL_ADMINISTRATOR_PASSWORD
    - OPAL_JAVA_MEM=<INSERT_VALUE_HERE>
    - MYSQLIDS_PORT_3306_TCP_ADDR=<INSERT_VALUE_HERE>
    - MYSQLIDS_PORT_3306_TCP_PORT=<INSERT_VALUE_HERE>
    - MYSQLIDS_DATABASE=<INSERT_VALUE_HERE>
    - MYSQLIDS_USER=<INSERT_VALUE_HERE>
    - MYSQLIDS_PASSWORD_FILE=/run/secrets/MYSQLIDS_PASSWORD
    - MYSQLDATA_PORT_3306_TCP_ADDR=<INSERT_VALUE_HERE>
    - MYSQLDATA_PORT_3306_TCP_PORT=<INSERT_VALUE_HERE>
    - MYSQLDATA_DATABASE=<INSERT_VALUE_HERE>
    - MYSQLDATA_USER=<INSERT_VALUE_HERE>
    - MYSQLDATA_PASSWORD_FILE=/run/secrets/MYSQLDATA_PASSWORD
    - DSBASE_VERSION=5.1.0
    - RSERVER_PORT_6312_TCP_ADDR=<INSERT_VALUE_HERE>
    - RSERVER_PORT_6312_TCP_PORT=<INSERT_VALUE_HERE>
    secrets:
    - OPAL_ADMINISTRATOR_PASSWORD
    - MYSQLIDS_PASSWORD
    - MYSQLDATA_PASSWORD
    volumes:
    - <PATH_TO_TAXONOMIES>:/usr/share/opal/taxonomies
    - opal:/srv

secrets:
  OPAL_ADMINISTRATOR_PASSWORD:
    external: true
  MYSQLIDS_PASSWORD:
    external: true
  MYSQLDATA_PASSWORD:
    external: true

volumes:
  opal:
```

<br>

---
master: [![pipeline status](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-opal-docker/badges/master/pipeline.svg)](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-opal-docker/commits/master)

dev: &emsp;&ensp;[![pipeline status](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-opal-docker/badges/dev/pipeline.svg)](https://gitlab.inesctec.pt/coral/coral-docker-images/coral-opal-docker/commits/dev)
