# ARG BASE_REGISTRY=registry1.dso.mil
# ARG BASE_IMAGE=ironbank/opensource/nodejs/nodejs18
# ARG BASE_TAG=18.18

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as builder

WORKDIR /app

# Unzip the tar.gz file that contains the latest release
RUN tar -xzf /tmp/pepr.tgz . && \
    mv pepr-* pepr && \
    mv pepr/* . 

COPY --chown=node:node . .

# Load only direct dependencies for Production use
RUN npm ci && \
    npm run build && \
    npm cache clean --force && \
    # Remove @types
    rm -fr node_modules/@types && \
    # Remove Ramda unused Ramda files
    rm -fr node_modules/ramda/dist && \
    rm -fr node_modules/ramda/es && \
    mkdir node_modules/pepr && \
    mv ./dist/ node_modules/pepr/dist && \
    mv package.json node_modules/pepr/package.json


FROM registry1.dso.mil/ironbank/opensource/nodejs/nodejs18:18.18

USER 65532:65532
WORKDIR /app
COPY --from=builder --chown=node:node /app/node_modules /app/node_modules
