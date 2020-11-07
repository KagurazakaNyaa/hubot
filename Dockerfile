# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image:    hubot
# name:     kagurazakanyaa/hubot
# repo:     https://github.com/KagurazakaNyaa/hubot
# Requires: node:alpine
# authors:  i@kagurazakanyaa.com
# ------------------------------------------------------

FROM node:lts-alpine

LABEL maintainer="i@kagurazakanyaa.com"

# Install hubot dependencies
RUN apk update\
 && apk upgrade\
 && apk add jq git\
 && npm install -g yo generator-hubot@next\
 && rm -rf /var/cache/apk/*

# Create hubot user with privileges
RUN addgroup -g 501 hubot\
 && adduser -D -h /hubot -u 501 -G hubot hubot
ENV HOME /home/hubot
WORKDIR $HOME
COPY entrypoint.sh ./
RUN chown -R hubot:hubot .
USER hubot

# Install hubot version HUBOT_VERSION
ENV HUBOT_NAME "hubot"
ENV HUBOT_OWNER "KagurazakaNyaa <i@kagurazakanyaa.com>"
ENV HUBOT_DESCRIPTION "A robot may not harm humanity, or, by inaction, allow humanity to come to harm"
RUN yo hubot\
 --owner="$HUBOT_OWNER"\
 --name="$HUBOT_NAME"\
 --description="$HUBOT_DESCRIPTION"\
 --defaults
ARG HUBOT_VERSION="3.3.2"
RUN jq --arg HUBOT_VERSION "$HUBOT_VERSION" '.dependencies.hubot = $HUBOT_VERSION' package.json > /tmp/package.json\
 && mv /tmp/package.json .

ENV HUBOT_ADAPTER xmpp
ENV HUBOT_ADAPTER_PACKAGE hubot-xmpp

EXPOSE 80

ENTRYPOINT ["./entrypoint.sh"]
