FROM ruby:3-alpine3.16

RUN apk add git ca-certificates libressl-dev \
    && update-ca-certificates \
    && apk update \
    && apk del openssl-dev \
    && rm -vf /var/cache/apk/* \
    && gem install concourse-github-status

WORKDIR /opt/resource

RUN find $(gem environment gemdirs) -type f -path '*/concourse-github-status-*/bin/*' -exec ln -s '{}' \;
