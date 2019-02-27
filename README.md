# OpenLDAP Docker Image for testing

![Docker Build Status](https://img.shields.io/docker/build/rroemhild/test-openldap.svg) ![Docker Stars](https://img.shields.io/docker/stars/rroemhild/test-openldap.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/rroemhild/test-openldap.svg)

This image provides an OpenLDAP Server for testing LDAP applications, i.e. unit tests. The server is initialized with the example domain `ldapmock.local` with data from the [Futurama Wiki][futuramawikia].

Parts of the image are based on the work from Nick Stenning [docker-slapd][slapd] and Bertrand Gouny [docker-openldap][openldap].

The Flask extension [flask-ldapconn][flaskldapconn] use this image for unit tests.

[slapd]: https://github.com/nickstenning/docker-slapd
[openldap]: https://github.com/osixia/docker-openldap
[flaskldapconn]: https://github.com/rroemhild/flask-ldapconn
[futuramawikia]: http://futurama.wikia.com


## Features

* Support for TLS (snake oil cert on build)
* Initialized with data from Futurama
* ~124MB images size (~40MB compressed)


## Usage

```
docker pull rroemhild/test-openldap
docker run --privileged -d -p 389:389 rroemhild/test-openldap
```

## Exposed ports

* 389
* 636

## LDAP structure

### dc=ldapmock,dc=local

| Admin            | Secret           |
| ---------------- | ---------------- |
| cn=admin,dc=ldapmock,dc=local | GoodNewsEveryone |

### ou=people,dc=ldapmock,dc=local

#### cn=Hubert J. Farnsworth,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| cn               | Hubert J. Farnsworth |
| sn               | Farnsworth |
| description      | Human |
| displayName      | Professor Farnsworth |
| employeeType     | Owner |
| employeeType     | Founder |
| givenName        | Hubert |
| jpegPhoto        | JPEG-Photo (630x507 Pixel, 26780 Bytes) |
| mail             | professor@ldapmock.local |
| mail             | hubert@ldapmock.local |
| ou               | Office Management |
| title            | Professor |
| uid              | professor |
| userPassword     | professor |


### cn=Philip J. Fry,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| cn               | Philip J. Fry |
| sn               | Fry |
| description      | Human |
| displayName      | Fry |
| employeeType     | Delivery boy |
| givenName        | Philip |
| jpegPhoto        | JPEG-Photo (429x350 Pixel, 22132 Bytes) |
| mail             | fry@ldapmock.local |
| ou               | Delivering Crew |
| uid              | fry |
| userPassword     | fry |


### cn=John A. Zoidberg,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| cn               | John A. Zoidberg |
| sn               | Zoidberg |
| description      | Decapodian |
| displayName      | Zoidberg |
| employeeType     | Doctor |
| givenName        | John |
| jpegPhoto        | JPEG-Photo (343x280 Pixel, 26438 Bytes) |
| mail             | zoidberg@ldapmock.local |
| ou               | Staff |
| title            | Ph. D. |
| uid              | zoidberg |
| userPassword     | zoidberg |

### cn=Hermes Conrad,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| cn               | Hermes Conrad |
| sn               | Conrad |
| description      | Human |
| employeeType     | Bureaucrat |
| employeeType     | Accountant |
| givenName        | Hermes |
| mail             | hermes@ldapmock.local |
| ou               | Office Management |
| uid              | hermes |
| userPassword     | hermes |

### cn=Turanga Leela,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| cn               | Turanga Leela |
| sn               | Turanga |
| description      | Mutant |
| employeeType     | Captain |
| employeeType     | Pilot |
| givenName        | Leela |
| jpegPhoto        | JPEG-Photo (429x350 Pixel, 26526 Bytes) |
| mail             | leela@ldapmock.local |
| ou               | Delivering Crew |
| uid              | leela |
| userPassword     | leela |

### cn=Bender Bending Rodríguez,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | inetOrgPerson |
| cn               | Bender Bending Rodríguez |
| sn               | Rodríguez |
| description      | Robot |
| employeeType     | Ship's Robot |
| givenName        | Bender |
| jpegPhoto        | JPEG-Photo (436x570 Pixel, 26819 Bytes) |
| mail             | bender@ldapmock.local |
| ou               | Delivering Crew |
| uid              | bender |
| userPassword     | bender |

### cn=admin_staff,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | Group |
| cn               | admin_staff |
| member           | cn=Hubert J. Farnsworth,ou=people,dc=ldapmock,dc=local |
| member           | cn=Hermes Conrad,ou=people,dc=ldapmock,dc=local |

### cn=ship_crew,ou=people,dc=ldapmock,dc=local

| Attribute        | Value            |
| ---------------- | ---------------- |
| objectClass      | Group |
| cn               | ship_crew |
| member           | cn=Turanga Leela,ou=people,dc=ldapmock,dc=local |
| member           | cn=Philip J. Fry,ou=people,dc=ldapmock,dc=local |
| member           | cn=Bender Bending Rodríguez,ou=people,dc=ldapmock,dc=local |
