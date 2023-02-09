# ------------------------------------------- Base build

ARG NODE_VERSION

FROM node:${NODE_VERSION} as base

RUN apk add --no-cache zip=3.0-r10

# ------------------ Build production application assets

FROM base as build

ARG BUILD_FOLDER=/usr/src/build
ARG RAW_FOLDER=/usr/src/raw

RUN mkdir -p ${BUILD_FOLDER} ${RAW_FOLDER}

WORKDIR ${RAW_FOLDER}

RUN env

COPY lambda/package*.json ./

RUN npm i --omit=dev

COPY lambda .

RUN zip -r ${BUILD_FOLDER}/lambda.zip .

# --------------------------- Build container entrypoint

FROM localstack/localstack

COPY --from=build /usr/src/build/lambda.zip ./lambda.zip
