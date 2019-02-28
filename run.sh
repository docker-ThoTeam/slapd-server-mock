#!/bin/sh
set -e

# Get variable or set defaults
readonly BOOTSTRAP_DIR=${BOOTSTRAP_DIR:-/bootstrap}
readonly LDAP_SECRET=${LDAP_SECRET:-adminpass}
readonly LDAP_DOMAIN=${LDAP_DOMAIN:-ldapmock.local}
readonly LDAP_ORGANISATION=${LDAP_ORGANISATION:-LDAP Mock, Inc.}
readonly LDAP_DEBUG_LEVEL=${LDAP_DEBUG_LEVEL:-256}
readonly LDAP_BINDDN=${LDAP_BINDDN:-cn=admin,dc=ldapmock,dc=local}
readonly LDAP_DEBUG_LEVEL=${LDAP_DEBUG_LEVEL:-256}

# These are not supposed to be customized for now
readonly LDAP_SSL_KEY="/etc/ldap/ssl/ldap.key"
readonly LDAP_SSL_CERT="/etc/ldap/ssl/ldap.crt"

echo "Configuring slapd mock instance"
/bin/bash /slapd-init.sh

echo "starting slapd on port 389 and 636..."
chown -R openldap:openldap /etc/ldap
exec /usr/sbin/slapd -h "ldap:/// ldapi:/// ldaps:///" \
  -u openldap \
  -g openldap \
  -d ${LDAP_DEBUG_LEVEL}
