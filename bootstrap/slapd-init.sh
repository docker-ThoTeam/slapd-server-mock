#!/bin/sh
set -eu

readonly BOOTSTRAP_DIR="/bootstrap"

readonly LDAP_DOMAIN=ldapmock.local
readonly LDAP_ORGANISATION="LDAP Mock, Inc."
readonly LDAP_BINDDN="cn=admin,dc=ldapmock,dc=local"
readonly LDAP_SECRET=GoodNewsEveryone

readonly LDAP_SSL_KEY="/etc/ldap/ssl/ldap.key"
readonly LDAP_SSL_CERT="/etc/ldap/ssl/ldap.crt"


reconfigure_slapd() {
    echo "Reconfigure slapd..."
    cat <<EOL | debconf-set-selections
slapd slapd/internal/generated_adminpw password ${LDAP_SECRET}
slapd slapd/internal/adminpw password ${LDAP_SECRET}
slapd slapd/password2 password ${LDAP_SECRET}
slapd slapd/password1 password ${LDAP_SECRET}
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/domain string ${LDAP_DOMAIN}
slapd shared/organization string ${LDAP_ORGANISATION}
slapd slapd/backend string HDB
slapd slapd/purge_database boolean true
slapd slapd/move_old_database boolean true
slapd slapd/allow_ldap_v2 boolean false
slapd slapd/no_configuration boolean false
slapd slapd/dump_database select when needed
EOL

    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure slapd
}


make_snakeoil_certificate() {
    echo "Make snakeoil certificate for ${LDAP_DOMAIN}..."
    openssl req -subj "/CN=${LDAP_DOMAIN}" \
                -new \
                -newkey rsa:2048 \
                -days 365 \
                -nodes \
                -x509 \
                -keyout ${LDAP_SSL_KEY} \
                -out ${LDAP_SSL_CERT}

    chmod 600 ${LDAP_SSL_KEY}
}


configure_features() {
    echo "Configure MSAD extension, TLS and loging"
    ldapmodify -Y EXTERNAL -H ldapi:/// -f ${BOOTSTRAP_DIR}/config.ldif -Q
}

load_initial_data() {
    echo "Load data..."
    local data=${BOOTSTRAP_DIR}/data.ldif
    echo "Processing file ${data}..."
    ldapadd -x -H ldapi:/// \
      -D ${LDAP_BINDDN} \
      -w ${LDAP_SECRET} \
      -f ${data}
}


## Init

reconfigure_slapd
make_snakeoil_certificate
chown -R openldap:openldap /etc/ldap
slapd -h "ldapi:///" -u openldap -g openldap

configure_features
load_initial_data

kill -INT `cat /run/slapd/slapd.pid`

exit 0
