FROM node:18-alpine

RUN apk --no-cache add git

COPY package.json /smartbed-mqttV2/
COPY yarn.lock /smartbed-mqttV2/
WORKDIR /smartbed-mqttV2

RUN yarn install

COPY src /smartbed-mqttV2/src/
COPY tsconfig.build.json /smartbed-mqttV2/
COPY tsconfig.json /smartbed-mqttV2/

RUN yarn build:ci

FROM node:18-alpine

# Add env
ENV LANG C.UTF-8

RUN apk add --no-cache bash curl jq && \
    curl -J -L -o /tmp/bashio.tar.gz "https://github.com/hassio-addons/bashio/archive/v0.13.1.tar.gz" && \
    mkdir /tmp/bashio && \
    tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /smartbed-mqttV2
COPY run.sh /smartbed-mqttV2/
RUN chmod a+x run.sh

COPY --from=0 /smartbed-mqttV2/node_modules /smartbed-mqttV2/node_modules
COPY --from=0 /smartbed-mqttV2/dist/tsc/ /smartbed-mqttV2/

ENTRYPOINT [ "/smartbed-mqttV2/run.sh" ]
#ENTRYPOINT [ "node", "index.js" ]
LABEL \
    io.hass.name="Smartbed Integration via MQTT" \
    io.hass.description="Home Assistant Community Add-on for Smartbeds" \
    io.hass.type="addon" \
    io.hass.version="1.1.22" \
    maintainer="Richard Hopton <richard@thehoptons.com>"