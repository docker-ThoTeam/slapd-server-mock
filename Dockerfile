FROM debian:bookworm-slim
LABEL maintainter="Olivier Clavel <olivier.clavel@thoteam.com>"

# Install slapd and requirements
RUN \
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    slapd \
    ldap-utils \
    openssl \
    ca-certificates \
    gettext-base && \
  mkdir /etc/ldap/ssl /bootstrap

# ADD sh scripts
COPY *.sh /

# ADD bootstrap files
COPY bootstrap /bootstrap

EXPOSE 389 636

CMD ["/bin/bash", "/run.sh"]
ENTRYPOINT []
