# -------------------------------------------------------------- Base build

ARG NODE_VERSION

FROM node:${NODE_VERSION} as base

ARG GID=1001
ARG UID=1001

RUN apk add shadow=4.13-r0 --no-cache && \
    groupmod -g ${GID} node && usermod -u ${UID} -g ${GID} node && \
    apk del shadow

# ------------------------------------- Build production application assets

FROM base as build

ARG BUILD_FOLDER=/usr/src/build
ARG LITERAL=mock-ui
ARG RAW_FOLDER=/usr/src/raw

RUN mkdir -p ${BUILD_FOLDER} ${RAW_FOLDER} && \
    chown -R node:node ${BUILD_FOLDER} ${RAW_FOLDER}

USER node

WORKDIR ${RAW_FOLDER}

RUN mkdir -p ${BUILD_FOLDER} ${RAW_FOLDER}

WORKDIR ${RAW_FOLDER}

COPY --chown=node:node ${LITERAL}/package*.json ./

RUN npm i --omit=dev

COPY --chown=node:node ${LITERAL} .

RUN npm pack

RUN tar -xf ${RAW_FOLDER}/${LITERAL}*.tgz --strip=1 -C ${BUILD_FOLDER} && \
    cp -R ${RAW_FOLDER}/node_modules ${BUILD_FOLDER}/

# ---------------------------------------------- Build container entrypoint

FROM base

ARG APP_FOLDER=/home/node/app

RUN mkdir -p ${APP_FOLDER} && \
    chown -R node:node ${APP_FOLDER}

USER node

WORKDIR ${APP_FOLDER}

COPY --from=build /usr/src/build .

CMD ["node", "server.js"]
