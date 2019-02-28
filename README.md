# OpenLDAP docker image with configurable mock data for testing

![Docker Build Status](https://img.shields.io/docker/build/thoteam/slapd-server-mock.svg) ![Docker Stars](https://img.shields.io/docker/stars/thoteam/slapd-server-mock.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/thoteam/slapd-server-mock.svg)

This image provides an OpenLDAP Server for testing LDAP applications, i.e. unit tests.
By default, the server is initialized with the example domain `ldapmock.local` with set of posix users/groups.


The starting point is based on the work from @rroemhild [docker-test-ldap](https://github.com/rroemhild/docker-test-openldap)

**As the title suggests, this is for testing only and you should not try to use this on any kind of production.** Slapd configuration
is minimal and the container does not store any data in persistent volumes. The mock data is bootstrapped each time the container
is created and lost everytime you remove it.

## Features

* Support for TLS (snake oil cert on build)
* Initialized on container start with default mock data or your own configured data (see below)
* ~110MB images size (~30MB bzip compressed)


## Usage

You first need to get the image locally

```bash
docker pull thoteam/slapd-server-mock
```

### Launching with default data

You can quickly launch a container which will be initialize with the default mock data
```bash
# Use access from other container on a docker network
docker run -d --name my_slapd_mock --network my-network thoteam/slapd-server-mock
# Access the slapd container from localhost or other host on your network
docker run -d -p 389:389 -p 636:636 --name my_slapd_mock thoteam/slapd-server-mock
```

### Customizing the container.

You can easilly customize the data used to initialize this mock instance through variables
and custom volume mounts for specific files.


#### Environment variables
You can set the following environment variables in your container

| variable          | default value                 | Usage                                                                               |
|-------------------|-------------------------------|-------------------------------------------------------------------------------------|
| LDAP_BINDDN       | cn=admin,dc=ldapmock,dc=local | Binddn for slapd admin. You must change it according to your changes in custom data |
| LDAP_SECRET       | adminpass                     | Password for slapdadmin                                                             |
| LDAP_DOMAIN       | ldapmock.local                | Used as the configured domain for slapd and to create the snakeoil ssl cert         |
| LDAP_ORGANISATION | LDAP Mock, Inc.               | Used as the configured organisation for slapd                                       |
| LDAP_DEBUG_LEVEL  | 256                           | Slapd debug level (see man slapd)                                                   |
| BOOTSTRAP_DIR     | /bootstrap                    | Directory holding boostrap files where `config.ldif` and `data.ldif` reside         |


#### Bootstrap config and data.

The [`run.sh`](run.sh) docker container command will launch [`slapd-init.sh`](slapd-init.sh)

[`slapd-init.sh`](slapd-init.sh) is expecting 2 ldif files in `$BOOTSTRAP_DIR`:
* [`config.ldif`](bootstrap/config.ldif) contains instruction to adapt slapd config and schema
* [`data.ldif`](bootstrap/data.ldif) contains the actual entries you want to find in your server (i.e. users and groups)

To override these files, simply bind mount your custom files from your local filesystem to the container. If needed
you can change the default `/bootstrap` directory location on the container by setting `$BOOTSTRAP_DIR`

```bash
# override data only
docker run -d --name my_slapd_mock -v /path/to/my/data.ldif:/bootstrap/data.ldif thoteam/slapd-server-mock

# override both data and config
docker run -d --name my_slapd_mock -v /path/to/my/bootstrap_dir:/bootstrap thoteam/slapd-server-mock

# override both on a custom location
docker run -d --name my_slapd_mock -v /path/to/my/bootstrap_dir:/customdir -e BOOTSTRAP_DIR=/customdir thoteam/slapd-server-mock
```

## Exposed ports

* 389 (ldap://)
* 636 (ldaps://)


## default LDAP structure

See the ldap objects definitions in [`bootstrap/data.ldif`](bootstrap/data.ldif) for details.
All users have the same password: `password`

```
dc=ldapmock,dc=local
|    cn=admin,dc=ldapmock,dc=local
|
└─── ou=people,dc=ldapmock,dc=local
|    |    uid=adminuser1,ou=people,dc=ldapmock,dc=local
|    |    uid=adminuser2,ou=people,dc=ldapmock,dc=local
|    |    uid=developper1,ou=people,dc=ldapmock,dc=local
|    |    uid=developper2,ou=people,dc=ldapmock,dc=local
|    |    uid=developper3,ou=people,dc=ldapmock,dc=local
|    |    uid=developper4,ou=people,dc=ldapmock,dc=local
|
└─── ou=groups,dc=ldapmock,dc=local
     |
     └─── cn=admin,ou=groups,dc=ldapmock,dc=local
     |    |    memberUID:adminuser1
     |    |    memberUID:adminuser2
     |
     └─── cn=admin,ou=groups,dc=ldapmock,dc=local
          |    memberUID:developper1
          |    memberUID:developper2
          |    memberUID:developper3
          |    memberUID:developper4
```
