ARG ESPHOME_VERSION=2026.4.0
FROM bitnami/minideb:latest
LABEL maintainer="Björn Busse <bj.rn@baerlin.eu>"
LABEL org.opencontainers.image.source https://github.com/bbusse/esphome-build

ARG ESPHOME_VERSION
ENV ARCH="x86_64" \
    USER="build" \
    PACKAGES="curl git python3 python3-pip python3-venv python3-launchpadlib" \
    PYTHON_PACKAGES="esphome>=${ESPHOME_VERSION}"

RUN ls -al && \
    adduser $USER && \
    apt update && \
    apt install -y ${PACKAGES}

USER $USER

RUN cd && ls -al && \
    python3 -m venv esphome && \
    . esphome/bin/activate && \
    pip3 install ${PYTHON_PACKAGES}

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
